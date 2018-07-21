require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/Worker')

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


# SEARCH

post '/workers/search_results' do
  @found_workers = Worker.find_by_experience_fuzzy(params['query'])
  erb(:"workers/search_results")
end

# UPDATE

post '/workers/:id' do
  worker = Worker.new(params)
  worker.update()
  redirect to "/workers/#{worker.id}"
end

# DESTROY

post '/workers/:id/delete' do
  worker = Worker.find(params['id'])
  worker.delete()
  redirect to "/workers"
end
