require_relative('../db/sql_runner.rb')
require_relative('Worker.rb')
require_relative('Visit.rb')

class ServiceUser

  attr_accessor :id, :name, :weekly_budget, :available_budget

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @weekly_budget = options['weekly_budget'].to_f
    @available_budget = options['available_budget'].to_f
  end

  # CRUD methods.

  def save()
    sql = "INSERT INTO service_users(name, weekly_budget, available_budget) VALUES($1, $2, $3) RETURNING id"
    values = [@name, @weekly_budget, @available_budget]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE service_users SET (name, weekly_budget, available_budget) = ($1, $2, $3) WHERE id = $4"
    values = [@name, @weekly_budget, @available_budget, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM service_users WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def workers()
    sql = "SELECT DISTINCT workers.* FROM workers INNER JOIN visits ON workers.id = visits.worker_id WHERE visits.service_user_id = $1"
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

  def sort_visits_by_date()
    return visits().sort{|visit_1, visit_2| DateTime.parse(visit_1.visit_date + " " + visit_1.visit_time) <=>
    DateTime.parse(visit_2.visit_date + " " + visit_2.visit_time)}
  end

  def can_afford?(amount)
    return (@available_budget - amount > 0)
  end

  def reduce_budget(visit_id)
    visit = Visit.find(visit_id)
    @available_budget -= visit.get_cost()
    update()
  end

  def increase_budget(visit_id)
    visit = Visit.find(visit_id)
    @available_budget += visit.get_cost()
    update()
  end

  def cost_of_all_visits()
    total_cost = 0
    for visit in visits()
      total_cost += visit.get_cost()
    end
    return total_cost
  end

  def string_value_of_weekly_budget_used()
    return sprintf('%.2f', cost_of_all_visits())
  end

  def string_value_of_weekly_budget()
    return sprintf('%.2f', @weekly_budget)
  end

  def percentage_of_weekly_budget_used()
    return 100 - (100*@available_budget/@weekly_budget).to_i
  end

end
