require_relative('../db/sql_runner.rb')
require_relative('ServiceUser.rb')
require_relative('Visit.rb')
require('similar_text')

class Worker

  attr_accessor :id, :name, :gender, :can_drive, :hourly_rate, :experience, :keywords

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @gender = options['gender']
    @can_drive = options['can_drive']
    @hourly_rate = options['hourly_rate'].to_f
    @experience = options['experience']
    @keywords = options['keywords']?  options['keywords'] : ""
    create_keywords_string() unless options['keywords']
  end

  # The @keywords string will be used to help with the fuzzy search.

  def create_keywords_string()
    first_name = @name.slice(0..-4)
    @keywords << "#{first_name},"
    @keywords << "male, man, men," if @gender == "m"
    @keywords << "female, woman, women," if @gender == "f"
    @keywords << "can drive, driver, driving," if @can_drive == true
    @keywords << "cheap, low cost," if @hourly_rate <= 8.75
  end

  def get_info()
    return "#{@name}, gender: #{@gender}, can drive: #{@can_drive}, hourly rate: #{@hourly_rate}, experience: #{@experience}"
  end

  def save()
    sql = "INSERT INTO workers(name, gender, can_drive, hourly_rate, experience, keywords) VALUES($1, $2, $3, $4, $5, $6) RETURNING id"
    values = [@name, @gender, @can_drive, @hourly_rate, @experience, @keywords]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE workers SET (name, gender, can_drive, hourly_rate, experience, keywords) = ($1, $2, $3, $4, $5, $6) WHERE id = $7"
    values = [@name, @gender, @can_drive, @hourly_rate, @experience, @keywords, @id]
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
    return self.all() if gender == "a"
    sql = "SELECT * FROM workers WHERE gender = $1"
    values = [gender]
    results = SqlRunner.run(sql, values)
    return results.map{|worker_info| Worker.new(worker_info)}
  end

  def self.find_by_can_drive()
    sql = "SELECT * FROM workers WHERE can_drive = TRUE"
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

  def self.find_by_experience_all_types(gender, can_drive, max_hourly_rate, experience = "any")
    returned_workers = []
    for worker in self.all()
      if worker.gender() == gender || gender == "a"
        if worker.can_drive() == can_drive
          if worker.hourly_rate() <= max_hourly_rate
            if worker.experience_matches?(worker.experience(), experience, 100) || experience == "any"
              returned_workers << worker
            end
          end
        end
      end
    end
    return returned_workers
  end

#  For searching using the search bar, where a user may type words with the incorrect spelling.

  def self.find_by_experience_fuzzy(searched)
    all_workers = self.all()
    return all_workers if searched.strip == ""
    returned_workers = []
    for worker in all_workers
      if worker.experience_matches?(worker.experience(), searched, 60) || worker.experience_matches?(worker.keywords(), searched, 80)
        returned_workers << worker
      end
    end
    return returned_workers
  end

#  Creates a string array and iterates through it, then returns true if any word matches the searched word by at least a certain percentage.

  def experience_matches?(compared, searched, percentage)
    compared_string_array = compared.split(",")
    for string in compared_string_array
      return true if string.strip.downcase.similar(searched.strip.downcase) >= percentage
    end
    return false
  end


end
