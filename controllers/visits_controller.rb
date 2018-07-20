require('sinatra')
require('sinatra/contrib/all') if development?
also_reload('../models/*')
require_relative('../models/Visit')


# INDEX

get '/visits/?' do
  @visits = Visit.all()
  erb(:"visits/index")
end

# NEW

get '/visits/new/?' do
  erb(:"visits/new")
end

# CREATE

post '/visits' do
  Visit.new(params).save()
  redirect to "/visits"
end

# SHOW

get '/visits/:id/?' do
  @visit = Visit.find(params['id'])
  erb(:"visits/show")
end

# EDIT

get '/visits/:id/edit/?' do
  @visit = Visit.find(params['id'])
  erb(:"visits/edit")
end

# UPDATE

post '/visits/:id' do
  visit = Visit.new(params)
  visit.update()
  redirect to "/visits/#{visit.id()}"
end

# DESTROY

post '/visits/:id/delete' do
  visit = Visit.find(params['id'])
  visit.delete()
  redirect to "/visits"
end
