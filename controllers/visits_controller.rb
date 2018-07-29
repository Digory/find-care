require('sinatra')
require('sinatra/contrib/all') if development?
require_relative('../models/Visit')


# INDEX

get '/visits' do
  @visits = Visit.all()
  erb(:"visits/index")
end

# NEW

get '/visits/new' do
  erb(:"visits/new")
end

# CREATE

post '/visits' do
  Visit.new(params).save()
  redirect to "/visits"
end

# SHOW BEFORE DELETION

get '/visits/show_before_deletion' do
  @visit = Visit.find(params['visit_id'])
  erb(:"visits/show_before_deletion")
end

# SHOW

get '/visits/:id' do
  @visit = Visit.find(params['id'])
  erb(:"visits/show")
end

# UPDATE

post '/visits/:id' do
  visit = Visit.new(params)
  visit.update()
  redirect to "/visits/#{visit.id()}"
end

# EDIT

get '/visits/:id/edit' do
  @visit = Visit.find(params['id'])
  erb(:"visits/edit")
end

# APPROVE

post '/visits/:id/approve' do
  visit = Visit.find(params['id'])
  visit.approve()
  redirect to "/workers/#{params['worker_id']}"
end

# DESTROY

post '/visits/:id/delete' do
  visit = Visit.find(params['id'])
  service_user = ServiceUser.find(visit.service_user_id())
  service_user.increase_budget(visit.id())
  visit.delete()
  redirect to "/workers/#{params['worker_id']}" if params['worker_id']
  redirect to "/service_users/#{service_user.id()}"
end
