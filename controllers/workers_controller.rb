require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/Worker')

get '/workers/?' do
  @workers = Worker.all()
  erb(:"workers/index")
end
