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
# CREATE
# SHOW
# EDIT
# UPDATE
# DESTROY
