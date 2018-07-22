require_relative('../models/ServiceUser.rb')
require_relative('../models/Worker.rb')
require_relative('../models/Visit.rb')

class SeedsForTesting

  attr_accessor :service_user_1, :service_user_2, :service_user_3,
              :worker_1, :worker_2, :worker_3, :worker_4, :worker_5, :worker_6,
              :visit_1, :visit_2, :visit_3

  def initialize()

    ServiceUser.delete_all()
    Worker.delete_all()

    @service_user_1 = ServiceUser.new({
      'name' => 'M. Stephens',
      'weekly_budget' => 800
      })
    @service_user_1.save()

    @service_user_2 = ServiceUser.new({
      'name' => 'C. Henry',
      'weekly_budget' => 1500
      })
    @service_user_2.save()

    @service_user_3 = ServiceUser.new({
      'name' => 'D. Mitchell',
      'weekly_budget' => 90
      })
    @service_user_3.save()

    @worker_1 = Worker.new({
      'name' => 'James T.',
      'gender' => 'm',
      'can_drive' => true,
      'hourly_rate' => 10.50,
      'experience' => 'Visual Impairment,Autism,First Aid'
      })
    @worker_1.save()

    @worker_2 = Worker.new({
      'name' => 'Lorna H.',
      'gender' => 'f',
      'can_drive' => false,
      'hourly_rate' => 8.75,
      'experience' => 'Sign Language,Autism,Children'
      })
    @worker_2.save()

    @worker_3 = Worker.new({
      'name' => 'Bob L.',
      'gender' => 'm',
      'can_drive' => true,
      'hourly_rate' => 9.20,
      'experience' => 'Moving and Handling'
      })
    @worker_3.save()

    @worker_4 = Worker.new({
      'name' => 'Jenna F.',
      'gender' => 'f',
      'can_drive' => true,
      'hourly_rate' => 8.50,
      'experience' => 'Children,Moving and Handling,Peg Feeding'
      })
    @worker_4.save()

    @worker_5 = Worker.new({
      'name' => 'Bill N.',
      'gender' => 'm',
      'can_drive' => false,
      'hourly_rate' => 9.00,
      'experience' => ''
      })
    @worker_5.save()

    @worker_6 = Worker.new({
      'name' => 'Jillian M.',
      'gender' => 'f',
      'can_drive' => true,
      'hourly_rate' => 11.30,
      'experience' => 'Autism,Food Hygiene,First Aid'
      })
    @worker_6.save()

    @visit_1 = Visit.new({
      'service_user_id' => service_user_1.id,
      'worker_id' => worker_1.id,
      'visit_date' => '2018-06-01',
      'visit_time' => '09:00:00',
      'duration' => 2.5
      })
    @visit_1.save()

    @visit_2 = Visit.new({
      'service_user_id' => service_user_1.id,
      'worker_id' => worker_1.id,
      'visit_date' => '2018-08-06',
      'visit_time' => '11:00:00',
      'duration' => 4
      })
    @visit_2.save()

    @visit_3 = Visit.new({
      'service_user_id' => service_user_3.id,
      'worker_id' => worker_2.id,
      'visit_date' => '2018-09-30',
      'visit_time' => '22:00:00',
      'duration' => 2
      })
    @visit_3.save()
  end
end
