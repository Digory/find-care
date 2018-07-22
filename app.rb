require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('./models/*')
require_relative('controllers/service_users_controller.rb')
require_relative('controllers/workers_controller.rb')
require_relative('controllers/visits_controller.rb')


# INDEX

get '/' do
  erb(:index)
end

# ADMIN

get '/admin' do
  @workers = Worker.all()
  erb(:admin)
end
