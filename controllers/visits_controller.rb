require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/Visit')

get '/visits/?' do
  @visits = Visit.all()
  erb(:"visits/index")
end
