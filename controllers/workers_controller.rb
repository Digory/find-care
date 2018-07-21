require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/Worker')
require_relative('../models/ServiceUser')
require_relative('../models/Visit')

# INDEX

get '/workers/?' do
  @workers = Worker.all()
  erb(:"workers/index")
end

# NEW

get '/workers/new/?' do
  erb(:"workers/new")
end

# CREATE

post '/workers' do
  Worker.new(params).save()
  redirect to "/workers"
end

# SHOW

get '/workers/:id' do
  @worker = Worker.find(params['id'])
  erb(:"workers/show")
end

# EDIT

get '/workers/:id/edit/?' do
  @worker = Worker.find(params['id'])
  erb(:"workers/edit")
end

# FUZZY SEARCH

post '/workers/search_results/:id/fuzzy_search' do
  @found_workers = Worker.find_by_experience_fuzzy(params['query'])
  @service_user = ServiceUser.find(params['id'])
  erb(:"workers/search_results")
end

# SPECIFIC SEARCH

post '/workers/search_results/:id/specific' do
  @found_workers = Worker.find_by_experience_all_types(params['gender'],"t", 12, "Autism")
  @service_user = ServiceUser.find(params['id'])
  erb(:"workers/search_results")
end

# UPDATE

post '/workers/:id' do
  worker = Worker.new(params)
  worker.update()
  redirect to "/workers/#{worker.id()}"
end

# BOOK WORKER

post '/workers/:worker_id/book_worker/:service_user_id' do
  @worker = Worker.find(params['worker_id'])
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"workers/book")
end

# CONFIRM BOOKING

post '/workers/:worker_id/confirm_booking/:service_user_id' do
  worker = Worker.find(params['worker_id'])
  service_user = ServiceUser.find(params['service_user_id'])
  if service_user.reduce_weekly_budget?(worker.hourly_rate() * params['visit_duration'].to_f)
    visit = Visit.new({
      'service_user_id' => service_user.id(),
      'worker_id' => worker.id(),
      'visit_date' => params['visit_date'],
      'visit_time' => params['visit_time'],
      'duration' => params['visit_duration']
      })
      visit.save()
      redirect to "/service_users/#{service_user.id()}"
    else
      redirect to "/service_users/#{service_user.id()}/failed"
    end
end

# DESTROY

post '/workers/:id/delete' do
  worker = Worker.find(params['id'])
  worker.delete()
  redirect to "/workers"
end
