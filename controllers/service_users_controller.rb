require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/ServiceUser')

# INDEX

get '/service_users/?' do
  @service_users = ServiceUser.all()
  erb(:"service_users/index")
end

# NEW

get '/service_users/new/?' do
  erb(:"service_users/new")
end

# CREATE

post '/service_users' do
  ServiceUser.new(params).save()
  redirect to "/service_users"
end

# SHOW

get '/service_users/:id' do
  @service_user = ServiceUser.find(params['id'])
  erb(:"service_users/show")
end

# FAILED BOOKING

get '/service_users/:id/failed' do
  @service_user_id = params['id']
  erb(:"service_users/failed")
end

# EDIT

get '/service_users/:id/edit/?' do
  @service_user = ServiceUser.find(params['id'])
  erb(:"service_users/edit")
end

# UPDATE

post '/service_users/:id' do
  service_user = ServiceUser.new(params)
  service_user.update()
  redirect to "/service_users/#{service_user.id()}"
end

# DESTROY

post '/service_users/:id/delete' do
  service_user = ServiceUser.find(params['id'])
  service_user.delete()
  redirect to "/service_users"
end
