require_relative('../db/sql_runner.rb')
require_relative('ServiceUser.rb')
require_relative('Visit.rb')
require('similar_text')

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

  def self.find_by_experience_specific(experience)
    all_workers = self.all()
    returned_workers = []
    for worker in all_workers
      returned_workers << worker if worker.experience.match?(experience)
    end
    return returned_workers
  end

#  For searching using the search bar, where a user may type words with the incorrect spelling.

  def self.find_by_experience_fuzzy(experience)
    all_workers = self.all()
    returned_workers = []
    for worker in all_workers
      returned_workers << worker if worker.experience_matches?(worker.experience(), experience)
    end
    return returned_workers
  end

#  Iterates through a worker's experience, then returns true if each word matches the searched word by at least 60%.

  def experience_matches?(worker_experience, compared_experience)
    worker_experience_string_array = worker_experience.split(",")
    for string in worker_experience_string_array
      return true if string.strip.downcase.similar(compared_experience.downcase) >= 60
    end
    return false
  end



end
