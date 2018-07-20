require_relative('../db/sql_runner.rb')
require_relative('Worker.rb')
require_relative('ServiceUser.rb')

class ServiceUser

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @service_user_id = options['service_user_id'].to_i
    @worker_id = options['worker_id'].to_i
  end

  def save()
    sql = "INSERT INTO visits(service_user_id, worker_id) VALUES($1, $2) RETURNING id"
    values = [@service_user_id, @worker_id]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE visits SET (service_user_id, worker_id) = ($1, $2) WHERE id = $3"
    values = [@service_user_id, @worker_id, @id]
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
    sql = "SELECT * visits"
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
