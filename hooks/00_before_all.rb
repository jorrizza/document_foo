before do
  if logged_in?
    @me = User.where(username: session[:username]).first
  end
  @grid = Mongo::Grid.new Mongoid.config.master
end

before '*' do |path|
  # Assume /stuff/new,edit,delete/id
  @action = path.split('/')[2].to_s.to_sym
end
