require_relative('../db/sql_runner.rb')
require_relative('Worker.rb')
require_relative('Visit.rb')

class ServiceUser

  attr_accessor :id, :name, :weekly_budget

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @weekly_budget = options['weekly_budget'].to_f
  end

  def save()
    sql = "INSERT INTO service_users(name, weekly_budget) VALUES($1, $2) RETURNING id"
    values = [@name, @weekly_budget]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE service_users SET (name, weekly_budget) = ($1, $2) WHERE id = $3"
    values = [@name, @weekly_budget, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM service_users WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def workers()
    sql = "SELECT workers.* FROM workers INNER JOIN visits ON workers.id = visits.worker_id WHERE visits.service_user_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|worker_info| Worker.new(worker_info)}
  end

  def visits()
    sql = "SELECT * FROM visits WHERE service_user_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|visit_info| Visit.new(visit_info)}
  end

  def self.all()
    sql = "SELECT * FROM service_users"
    results = SqlRunner.run(sql)
    return results.map{|service_user_info| ServiceUser.new(service_user_info)}
  end

  def self.find(id)
    sql = "SELECT * FROM service_users WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return ServiceUser.new(result.first)
  end

  def self.delete_all()
    sql = "DELETE FROM service_users"
    SqlRunner.run(sql)
  end
end
