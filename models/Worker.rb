require_relative('../db/sql_runner.rb')
require_relative('ServiceUser.rb')
require_relative('Visit.rb')
require('similar_text')

class Worker

  attr_accessor :id, :name, :gender, :can_drive, :hourly_rate, :experience, :approved, :keywords

  $cost_multiplier = 1.28

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @gender = options['gender']
    @can_drive = options['can_drive'] == 't'? true : false
    @hourly_rate = options['hourly_rate'].to_f
    @experience = options['experience']


    @approved =  options['approved'] == 't' ? true : false
    @keywords = options['keywords']?  options['keywords'] : ""
    create_keywords_string() unless options['keywords']
  end

  # The @keywords string will be used to help with the keyword search.

   def create_keywords_string()
    @keywords << "#{name},"
    @keywords << "male, man, men," if @gender == "m"
    @keywords << "female, woman, women," if @gender == "f"
    @keywords << "can drive, driver, driving," if @can_drive == true
    @keywords << "cheap, low cost," if @hourly_rate <= 8.75
    update()
  end

  def get_info()
    info_string = "#{@name} is a "
    case @gender
    when "m"
      add_to_string = "male "
    when "f"
      add_to_string = "female "
    when "a"
      add_to_string = "non-binary "
    end
    info_string += add_to_string
    add_to_string = @can_drive? "driver." : "non-driver."
    info_string += add_to_string + " Experience: #{@experience}. Hourly rate: £#{cost_to_employer()}"
    return info_string
  end

  # def experience_string()
  #   return @experience.gsub(","," ")
  # end

  def approve()
    @approved = true
    update()
  end

  def approved_string()
    return (@approved? "" : "AWAITING ADMIN APPROVAL")
  end

  def hours_afforded(service_user)
    # service_user = ServiceUser.find(service_user_id)
    return (service_user.available_budget/(@hourly_rate*$cost_multiplier)).to_i
  end
  #
  # def check_database_for_approved()
  #   sql = "SELECT approved FROM workers WHERE id = $1"
  #   values = [@id]
  #   result = SqlRunner.run(sql, values)
  #   return result.first['approved']
  # end

  def cost_to_employer()
    return sprintf('%.2f', @hourly_rate * $cost_multiplier)
  end

  def save()
    sql = "INSERT INTO workers(name, gender, can_drive, hourly_rate, experience, keywords, approved) VALUES($1, $2, $3, $4, $5, $6, $7) RETURNING id"
    values = [@name, @gender, @can_drive, @hourly_rate, @experience, @keywords, @approved]
    result = SqlRunner.run(sql,values)
    @id = result.first['id'].to_i
  end

  def update()
    sql = "UPDATE workers SET (name, gender, can_drive, hourly_rate, experience, keywords, approved) = ($1, $2, $3, $4, $5, $6, $7) WHERE id = $8"
    values = [@name, @gender, @can_drive, @hourly_rate, @experience, @keywords, @approved, @id]
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

  # When a worker is deleted, any service users they were linked to have to have their budget increased back to what it was.

  def fix_service_users_budgets()
    for visit in visits()
       ServiceUser.find(visit.service_user_id).increase_budget(visit.id())
    end
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

  def self.sort_by_cost(workers)
    return workers.sort_by{|worker| worker.hourly_rate()}
  end

  def self.remove_unapproved(workers)
    return workers.select{|worker| worker.approved() == true}
  end

  def self.remove_approved(workers)
    return workers.select{|worker| worker.approved() == false}
  end

  def does_experience_match_all_filters?(searched_array)
    return true if searched_array.include?("any")
    worker_experience_array = @experience.split(",")
    return searched_array.all?{|string| worker_experience_array.include?(string)}
  end

  # For searching using filters.

  def self.filtered_search(gender, can_drive, max_hourly_rate, searched_array)
    found_workers = []
    for worker in self.all()
      if worker.gender() == gender || gender == "a"
        if worker.can_drive() == true || can_drive == "a"
          if worker.hourly_rate() <= max_hourly_rate.to_f/$cost_multiplier
            if worker.does_experience_match_all_filters?(searched_array)
              found_workers << worker
            end
          end
        end
      end
    end
    return found_workers
  end

#  For searching using the search bar, where a user may type words with the incorrect spelling.

  def self.keyword_search(searched)
    all_workers = self.all()
    return all_workers if searched.strip == ""
    found_workers = []
    for worker in all_workers
      if worker.experience_matches?(worker.experience(), searched, 60) || worker.experience_matches?(worker.keywords(), searched, 80)
        found_workers << worker
      end
    end
    return found_workers
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
