post '/login' do
  if User.auth(params[:username], params[:password])
    session[:username] = params[:username]
  else
    flash[:error] = "Wrong username and/or password."
  end

  redirect '/'
end

get '/logout' do
  session[:username] = nil

  redirect '/'
end
