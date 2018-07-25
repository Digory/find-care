require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/ServiceUser')
require_relative('../models/CheckDate')

# INDEX

get '/service_users' do
  @service_users = ServiceUser.all()
  erb(:"service_users/index")
end

# NEW

get '/service_users/new' do
  erb(:"service_users/new")
end

# SHOW SEARCH OPTIONS

get '/service_users/show_search_options' do
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"service_users/show_search_options")
end

# SHOW FILTERED SEARCH

get '/service_users/filtered_search' do
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"service_users/filtered_search")
end

# SHOW FUZZY SEARCH

get '/service_users/fuzzy_search' do
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"service_users/fuzzy_search")
end

# SHOW EDIT OR DELETE

get '/service_users/show_edit_or_delete' do
  @service_user = ServiceUser.find(params['service_user_id'])
  erb(:"service_users/show_edit_or_delete")
end

# CREATE

post '/service_users' do
  service_user = ServiceUser.new(params)
  service_user.available_budget = service_user.weekly_budget
  service_user.save()
  redirect to "/service_users"
end

# SHOW

get '/service_users/:id' do
  @service_user = ServiceUser.find(params['id'])
  erb(:"service_users/show")
end

# EDIT

get '/service_users/:id/edit' do
  @service_user = ServiceUser.find(params['id'])
  erb(:"service_users/edit")
end

# UPDATE

post '/service_users/:id' do
  service_user = ServiceUser.new(params)
  service_user.available_budget = service_user.weekly_budget
  service_user.update()
  redirect to "/service_users/#{service_user.id()}"
end

# DESTROY

post '/service_users/:id/delete' do
  service_user = ServiceUser.find(params['id'])
  service_user.delete()
  redirect to "/service_users"
end
