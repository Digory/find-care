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
  service_user = ServiceUser.find(visit.service_user_id())
  visit.delete()
  service_user.dynamically_update_budget()
  redirect to "/visits"
end

# APPROVE

post '/visits/:worker_id/approve_visit/:visit_id' do
  visit = Visit.find(params['visit_id'])
  visit.approve()
  redirect to "/workers/#{params['worker_id']}"
end
