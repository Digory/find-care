require_relative('../db/sql_runner.rb')
require_relative('ServiceUser.rb')
require_relative('Visit.rb')

class Worker

  attr_accessor :id, :name, :gender, :can_drive, :hourly_rate, :experience

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @gender = options['gender']
    @can_drive = options['can_drive']
    @hourly_rate = options['hourly_rate'].to_f
    @experience = options['experience']
  end

  def get_info()
    return "#{@name}, gender: #{@gender}, can drive: #{@can_drive}, hourly rate: #{@hourly_rate}, experience: #{@experience}"
  end

  def save()
    sql = "INSERT INTO workers(name, gender, can_drive, hourly_rate, experience) VALUES($1, $2, $3, $4, $5) RETURNING id"
    values = [@name, @gender, @can_drive, @hourly_rate, @experience]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE workers SET (name, gender, can_drive, hourly_rate, experience) = ($1, $2, $3, $4, $5) WHERE id = $6"
    values = [@name, @gender, @can_drive, @hourly_rate, @experience, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM workers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def service_users()
    sql = "SELECT DISTINCT service_users.* FROM service_users INNER JOIN visits ON service_users.id = visits.service_user_id WHERE visits.worker_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|service_user_info| ServiceUser.new(service_user_info)}
  end

  def visits()
    sql = "SELECT * FROM visits WHERE worker_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|visit_info| Visit.new(visit_info)}
  end

  def self.all()
    sql = "SELECT * FROM workers"
    results = SqlRunner.run(sql)
    return results.map{|worker_info| Worker.new(worker_info)}
  end

  def self.find(id)
    sql = "SELECT * FROM workers WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return Worker.new(result.first)
  end

  def self.delete_all()
    sql = "DELETE FROM workers"
    SqlRunner.run(sql)
  end

  def self.find_by_gender(gender)
    sql = "SELECT * FROM workers WHERE gender = $1"
    values = [gender]
    results = SqlRunner.run(sql, values)
    return results.map{|worker_info| Worker.new(worker_info)}
  end

  def self.find_by_can_drive(can_drive)
    sql = "SELECT * FROM workers WHERE can_drive = $1"
    values = [can_drive]
    results = SqlRunner.run(sql, values)
    return results.map{|worker_info| Worker.new(worker_info)}
  end

  def self.find_by_hourly_rate(max_hourly_rate)
    all_workers = self.all()
    returned_workers = []
    for worker in all_workers
      returned_workers << worker if worker.hourly_rate <= max_hourly_rate
    end
    return returned_workers
  end

  def self.find_by_experience(experience)
    all_workers = self.all()
    returned_workers = []
    for worker in all_workers
      returned_workers << worker if worker.experience.downcase.match?(experience.downcase)
    end
    return returned_workers
  end

end
