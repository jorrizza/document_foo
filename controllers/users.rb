get '/users/?' do
  @users = User.all

  erb :users
end

get '/users/new' do
  @user = User.new
  @accountants = User.where(role: :accountant).to_a.map do |acc|
    acc.username
  end
  
  erb :users_new
end

post '/users/new' do
  puts params[:username]
  @user = User.new(username: params[:username],
                  password: params[:password],
                  password_confirmation:
                  params[:password_confirmation],
                   role: params[:role].to_sym)
  @accountants = User.where(role: :accountant).to_a.map do |acc|
    acc.username
  end

  if !params[:accountant].empty? && @user.role == :customer
    @user.accountant = User.where(username: params[:accountant]).first
  end

  if @user.valid?
    flash[:success] = "User #{h params[:username]} has been successfully created."
    @user.save

    redirect '/users'
  else
    flash[:error] = "The user couldn't be added because "
    flash[:error] += @user.errors.map do |field, error|
      "#{field} #{error}"
    end.join(', ') + "."

    erb :users_new
  end
end

get '/users/edit/:id' do
  @user = User.where(_id: params[:id]).first
  @accountants = User.where(role: :accountant).to_a.map do |acc|
    acc.username
  end

  halt 404 unless @user

  erb :users_edit
end

post '/users/edit/:id' do
  @user = User.where(_id: params[:id]).first
  @accountants = User.where(role: :accountant).to_a.map do |acc|
    acc.username
  end

  if @user.role == :customer
    if !params[:accountant].empty?
      @user.accountant = User.where(username:
                                    params[:accountant]).first
    else
      @user.accountant = nil
    end
  end

  unless @user.username == 'admin'
    @user.write_attributes(username: params[:username],
                           role: params[:role].to_sym)
  else
    if params[:username] != @user.username || params[:role].to_sym != @user.role
      flash[:warning] = 'I will not edit the admin role or name.'
    end
  end

  unless params[:password].empty?
    @user.write_attributes(password: params[:password],
                           password_confirmation:
                           params[:password_confirmation])
  end

  if @user.valid?
    flash[:success] = "The changes to #{h params[:username]} have been saved successfully."
    @user.save

    redirect '/users'
  else
    flash[:error] = "The changes couldn't be saved because "
    flash[:error] += @user.errors.map do |field, error|
      "#{field} #{error}"
    end.join(', ') + "."

    erb :users_edit
  end
end

get '/users/delete/:id' do
  @user = User.where(_id: params[:id]).first
  halt 404 unless @user
  username = @user.username
  
  if username == 'admin'
    flash[:warning] = "I will not remove the admin user."
  else
    User.where(_id: params[:id]).destroy
    flash[:success] = "User #{h username} has been removed successfully."
  end

  redirect '/users'
end
