require_relative('../models/ServiceUser.rb')
require_relative('../models/Worker.rb')
require_relative('../models/Visit.rb')

ServiceUser.delete_all()
Worker.delete_all()

service_user_1 = ServiceUser.new({
  'name' => 'M. Stephens',
  'weekly_budget' => 300,
  'available_budget' => 300
  })
service_user_1.save()

service_user_2 = ServiceUser.new({
  'name' => 'C. Henry',
  'weekly_budget' => 100,
  'available_budget' => 100
  })
service_user_2.save()

service_user_3 = ServiceUser.new({
  'name' => 'D. Mitchell',
  'weekly_budget' => 500,
  'available_budget' => 500
  })
service_user_3.save()

worker_1 = Worker.new({
  'name' => 'Carlos',
  'gender' => 'm',
  'can_drive' => "t",
  'hourly_rate' => 10.50,
  'experience' => 'Visual Impairment,Autism,First Aid'
  })
worker_1.save()

worker_2 = Worker.new({
  'name' => 'Lorna',
  'gender' => 'f',
  'can_drive' => "f",
  'hourly_rate' => 8.75,
  'experience' => 'Sign Language,Autism,Children'
  })
worker_2.save()

worker_3 = Worker.new({
  'name' => 'Bob',
  'gender' => 'm',
  'can_drive' => "t",
  'hourly_rate' => 9.20,
  'experience' => 'Moving and Handling'
  })
worker_3.save()

worker_4 = Worker.new({
  'name' => 'Jennifer',
  'gender' => 'f',
  'can_drive' => "t",
  'hourly_rate' => 8.50,
  'experience' => 'Children,Moving and Handling,Peg Feeding'
  })
worker_4.save()

worker_5 = Worker.new({
  'name' => 'Bill',
  'gender' => 'm',
  'can_drive' => "f",
  'hourly_rate' => 9.00,
  'experience' => 'none'
  })
worker_5.save()

worker_6 = Worker.new({
  'name' => 'Jillian',
  'gender' => 'f',
  'can_drive' => "t",
  'hourly_rate' => 11.30,
  'experience' => 'Autism,Food Hygiene,First Aid'
  })
worker_6.save()

worker_7 = Worker.new({
  'name' => 'Barbara',
  'gender' => 'f',
  'can_drive' => "f",
  'hourly_rate' => 12.00,
  'experience' => 'Children'
  })
worker_7.save()

worker_8 = Worker.new({
  'name' => 'Scott',
  'gender' => 'm',
  'can_drive' => "f",
  'hourly_rate' => 10.00,
  'experience' => 'Peg Feeding,Sign Language'
  })
worker_8.save()

worker_8 = Worker.new({
  'name' => 'Jade',
  'gender' => 'f',
  'can_drive' => "t",
  'hourly_rate' => 9.50,
  'experience' => 'Children,Autism,Peg Feeding,Sign Language'
  })
worker_8.save()

worker_8 = Worker.new({
  'name' => 'Joe',
  'gender' => 'm',
  'can_drive' => "f",
  'hourly_rate' => 8.50,
  'experience' => 'Sign Language'
  })
worker_8.save()

worker_9 = Worker.new({
  'name' => 'Sarah',
  'gender' => 'f',
  'can_drive' => "f",
  'hourly_rate' => 14.50,
  'experience' => 'Children,Moving and Handling,Sign Language,First Aid,Visual Impairment'
  })
worker_9.save()

worker_10 = Worker.new({
  'name' => 'Simon',
  'gender' => 'm',
  'can_drive' => "t",
  'hourly_rate' => 13.50,
  'experience' => 'Visual Impairment'
  })
worker_10.save()

# visit_1 = Visit.new({
#   'service_user_id' => service_user_1.id,
#   'worker_id' => worker_1.id,
#   'visit_date' => '2018-06-01',
#   'visit_time' => '09:00:00',
#   'duration' => 2.5
#   })
# visit_1.save()
#
# visit_2 = Visit.new({
#   'service_user_id' => service_user_1.id,
#   'worker_id' => worker_1.id,
#   'visit_date' => '2018-08-06',
#   'visit_time' => '11:00:00',
#   'duration' => 4
#   })
# visit_2.save()
#
# visit_3 = Visit.new({
#   'service_user_id' => service_user_3.id,
#   'worker_id' => worker_2.id,
#   'visit_date' => '2018-09-30',
#   'visit_time' => '22:00:00',
#   'duration' => 2
#   })
# visit_3.save()
