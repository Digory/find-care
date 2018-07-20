require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/ServiceUser')

get '/service_users/?' do
  @service_users = ServiceUser.all()
  erb(:"service_users/index")
end
