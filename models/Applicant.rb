require_relative('Worker.rb')

class Applicant

  attr_accessor :name, :gender, :can_drive, :hourly_rate, :experience, :approved

  def initialize(options)
    @name = options['name']
    @gender = options['gender']
    @can_drive = options['can_drive']
    @hourly_rate = options['hourly_rate']
    @experience = options['experience']

    @workers = []

    create_worker()
    # @approved = false
  end

  def create_worker()
    worker = Worker.new({
      'name' => @name,
      'gender' => @gender,
      'can_drive' => @can_drive,
      'hourly_rate' => @hourly_rate,
      'experience' => @experience
      })

      @workers << worker
  end

  def self.approve(name)
    # @approved = true
    
    worker.save()
  end

  def self.see_current_applicants()

  end



end
