require_relative('../db/sql_runner.rb')
require_relative('Worker.rb')
require_relative('ServiceUser.rb')

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

  def get_details()
    worker = Worker.find(@worker_id)
    worker_cost = worker.hourly_rate() * @duration
    return "#{worker.name()} is coming on #{@visit_date} at #{@visit_time} for #{@duration} hours, at a cost of: £#{worker_cost}"
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
end
