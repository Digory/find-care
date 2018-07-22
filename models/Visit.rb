require_relative('../db/sql_runner.rb')
require_relative('Worker.rb')
require_relative('ServiceUser.rb')
require_relative('CheckDate.rb')

class Visit

  attr_accessor :id, :service_user_id, :worker_id, :visit_date, :visit_time, :duration

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @service_user_id = options['service_user_id'].to_i
    @worker_id = options['worker_id'].to_i
    @visit_date = options['visit_date']
    @visit_time = options['visit_time']
    @duration = options['duration'].to_f
  end

  def get_cost()
    worker = Worker.find(@worker_id)
    return worker.cost_to_employer().to_f * @duration
  end

  def get_details_for_service_user()
    worker_cost = get_cost()
    return "#{worker.name()} is coming on #{@visit_date} at #{@visit_time} for #{@duration} hours, at a cost of: £#{worker_cost}"
  end

  def get_details_for_worker()
    service_user = ServiceUser.find(@service_user_id)
    return "You are supporting #{service_user.name()} on #{@visit_date} at #{@visit_time} for #{@duration} hours."
  end

  def get_database_visit_date()
    sql = "SELECT visits.visit_date FROM visits WHERE id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.first['visit_date']
  end

  def get_database_visit_time()
    sql = "SELECT visits.visit_time FROM visits WHERE id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    return result.first['visit_time']
  end

  def increase_date_by_a_week()
    sql = "UPDATE visits SET visit_date = visit_date + 7 WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def save()
    sql = "INSERT INTO visits(service_user_id, worker_id, visit_date, visit_time, duration) VALUES($1, $2, $3, $4, $5) RETURNING id"
    values = [@service_user_id, @worker_id, @visit_date, @visit_time, @duration]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE visits SET (service_user_id, worker_id, visit_date, visit_time, duration) = ($1, $2, $3, $4, $5) WHERE id = $6"
    values = [@service_user_id, @worker_id, @visit_date, @visit_time, @duration, @id]
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

  def self.get_date_from_checkdate_string(date_and_time_string)
    return date_and_time_string[0..9]
  end

  def self.get_time_from_checkdate_string(date_and_time_string)
    return date_and_time_string[11..18]
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

  def self.create_with_these_parameters?(service_user_id, worker_id, visit_days, visit_time, duration)
    service_user = ServiceUser.find(service_user_id)
    worker_hourly_cost = Worker.find(worker_id).cost_to_employer().to_f
    total_hours = visit_days.size() * duration.to_f
    total_cost = worker_hourly_cost * total_hours

    if service_user.reduce_weekly_budget?(total_cost)
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
      end
      return true
    else
      return false
    end
  end
end
