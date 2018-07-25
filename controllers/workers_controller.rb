require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/Worker')
require_relative('../models/ServiceUser')
require_relative('../models/Visit')

# INDEX

get '/workers' do
  @workers = Worker.all()
  erb(:"workers/index")
end

# NEW

get '/workers/new' do
  erb(:"workers/new")
end

# CREATE

post '/workers' do
  worker = Worker.new(params)
  experience_string = ""
  for experience in params['experience']
    experience_string += experience + ","
  end
  worker.experience = experience_string
  worker.save()
  erb(:"workers/new_success")
end

# APPROVE

post '/workers/approve' do
  Worker.find(params['worker_id']).approve()
  redirect to "/workers/show_unapproved"
end

# SHOW TO ADMIN

get '/workers/show_unapproved' do
  @unapproved_workers = Worker.remove_approved(Worker.all())
  erb(:"workers/show_unapproved")
end

# SHOW TO SERVICE USER

get '/workers/view' do
  @worker = Worker.find(params['worker_id'])
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"workers/show_to_service_user")
end

# BOOK WORKER

get '/workers/book_worker' do
  @worker = Worker.find(params['worker_id'])
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"workers/book")
end

# SHOW TO WORKER

get '/workers/:id' do
  @worker = Worker.find(params['id'])
  erb(:"workers/show_to_worker")
end


# EDIT

get '/workers/:id/edit/?' do
  @worker = Worker.find(params['id'])
  erb(:"workers/edit")
end

# keyword SEARCH

get '/workers/search_results/keyword_search' do
  @found_workers = Worker.keyword_search(params['query'])
  @found_workers = Worker.sort_by_cost(@found_workers)
  @found_workers = Worker.remove_unapproved(@found_workers)
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"workers/search_results")
end

# FILTERED SEARCH

get '/workers/search_results/filtered_search' do
  @found_workers = Worker.filtered_search(params['gender'],params['can-drive'], params['max-hourly'], params['experience'])
  @found_workers = Worker.sort_by_cost(@found_workers)
  @found_workers = Worker.remove_unapproved(@found_workers)
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"workers/search_results")
end

# CONFIRM BOOKING

post '/workers/confirm_booking' do
  worker = Worker.find(params['worker_id'])
  @service_user = ServiceUser.find(params['service_user_id'])

  # If a service user cannot afford the visit they are told this, and the visit is not created.

  if Visit.create_with_these_parameters?(@service_user.id(), worker.id(), params['visit_days'],           params['visit_time'], params['duration'])
     redirect to "/service_users/#{@service_user.id()}"
    else
     erb(:"/workers/booking_failed")
    end
end

# UPDATE

post '/workers/:id' do
  worker = Worker.new(params)
  worker.update()
  redirect to "/workers/#{worker.id()}"
end


# DESTROY

post '/workers/:id/delete' do
  worker = Worker.find(params['id'])
  worker.fix_service_users_budgets()
  worker.delete()
  redirect to "/workers"
end
