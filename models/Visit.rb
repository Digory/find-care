require_relative('../db/sql_runner.rb')
require_relative('Worker.rb')
require_relative('ServiceUser.rb')
require_relative('CheckDate.rb')

class Visit

  attr_accessor :id, :service_user_id, :worker_id, :visit_date, :visit_time, :duration, :approved

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @service_user_id = options['service_user_id'].to_i
    @worker_id = options['worker_id'].to_i
    @visit_date = options['visit_date']
    @visit_time = options['visit_time']
    @duration = options['duration'].to_f
    @approved =  options['approved'] == 't' ? true : false
  end

  # CRUD methods.

  def save()
    sql = "INSERT INTO visits(service_user_id, worker_id, visit_date, visit_time, duration, approved) VALUES($1, $2, $3, $4, $5, $6) RETURNING id"
    values = [@service_user_id, @worker_id, @visit_date, @visit_time, @duration, @approved]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE visits SET (service_user_id, worker_id, visit_date, visit_time, duration, approved) = ($1, $2, $3, $4, $5, $6) WHERE id = $7"
    values = [@service_user_id, @worker_id, @visit_date, @visit_time, @duration, @approved, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM visits WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def worker()
    sql = "SELECT * FROM workers WHERE id = $1"
    values = [@worker_id]
    result = SqlRunner.run(sql, values)
    return Worker.new(result.first)
  end

  def service_user()
    sql = "SELECT * FROM service_users WHERE id = $1"
    values = [@service_user_id]
    result = SqlRunner.run(sql, values)
    return ServiceUser.new(result.first)
  end

  def self.all()
    sql = "SELECT * FROM visits"
    results = SqlRunner.run(sql)
    return results.map{|visit_info| Visit.new(visit_info)}
  end

  def self.find(id)
    sql = "SELECT * FROM visits WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return Visit.new(result.first)
  end

  def self.delete_all()
    sql = "DELETE FROM visits"
    SqlRunner.run(sql)
  end

  def increase_date_by_a_week()
    sql = "UPDATE visits SET visit_date = visit_date + 7 WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
    @visit_date = database_visit_date()
  end

  def database_visit_date()
    sql = "SELECT visit_date FROM VISITS WHERE id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    p result[0]['visit_date']
    return result[0]['visit_date']
  end

  # The service user can select multiple days, so multiple visits may be created. If the service user cannot afford the total cost then no visits will be created.

  def self.create_with_these_parameters?(service_user_id, worker_id, visit_days, visit_time, duration)
    service_user = ServiceUser.find(service_user_id)
    worker_hourly_cost = Worker.find(worker_id).cost_to_employer().to_f
    total_hours = visit_days.size() * duration.to_f
    total_cost = worker_hourly_cost * total_hours

    if service_user.can_afford?(total_cost)
      for day in visit_days
        date = self.get_date_from_checkdate_string(CheckDate.find_next_day_of_the_week(day, visit_time).to_s)
        time = self.get_time_from_checkdate_string(CheckDate.find_next_day_of_the_week(day, visit_time).to_s)
        visit = Visit.new({
          'service_user_id' => service_user_id,
          'worker_id' => worker_id,
          'visit_date' => date,
          'visit_time' => time,
          'duration' => duration})
          visit.save()
          service_user.reduce_budget(visit.id)
        end
        return true
      else
        return false
      end
    end

    def self.get_date_from_checkdate_string(date_and_time_string)
      return date_and_time_string[0..9]
    end

    def self.get_time_from_checkdate_string(date_and_time_string)
      return date_and_time_string[11..18]
    end

    def get_cost()
      worker = Worker.find(@worker_id)
      return worker.cost_to_employer().to_f * @duration
    end

    def approve()
      @approved = true
      update()
    end

    def get_details_for_service_user()
      return "#{worker.name()} is coming on #{DateTime.parse(@visit_date + " " + @visit_time).strftime("%A %B %-d at %l:%M%P")} for #{@duration} hours."
    end

    def add_to_get_details_for_service_user()
      return (approved()? "" : "Awaiting confirmation &#8594 ")
    end

    def get_details_for_worker()
      service_user = ServiceUser.find(@service_user_id)
      return "You are supporting #{service_user.name()} on #{@visit_date} at #{@visit_time[0..4]} for #{@duration} hours."
    end

  end
