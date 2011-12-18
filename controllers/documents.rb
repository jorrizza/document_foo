get '/documents/?' do
  if @me.role == :admin
    @documents = Document.all
  elsif @me.role == :accountant
    @documents = Document.where(:user_id.in => [@me._id] +
                                @me.users.map { |u| u._id })
  else
    @documents = @me.documents
  end
  
  erb :documents
end

get '/documents/new/?' do
  @document = Document.new
  if @me.role == :admin
    @owners = User.all.to_a.map do |user|
      user.username
    end
  elsif @me.role == :accountant
    @owners = [@me.username] + @me.users.map do |user|
      user.username
    end
  else
    @owners = nil
  end
  
  erb :documents_new
end

post '/documents/new/?' do
  if @me.role == :customer
    owner = @me
  else
    owner = User.where(username: params[:owner]).first
    halt 404 unless owner
  end
  
  @document = owner.documents.new(name: params[:name])

  if @me.role == :admin
    @owners = User.all.to_a.map do |user|
      user.username
    end
  elsif @me.role == :accountant
    @owners = [@me.username] + @me.users.map do |user|
      user.username
    end
  else
    @owners = nil
  end

  if @me.role != :customer
    halt 403 unless @owners.include? owner.username
  end

  if params[:file]
    @document.file = @grid.put(params[:file][:tempfile],
                               content_type: params[:file][:type],
                               filename: params[:file][:filename])
  end

  if @document.valid?
    @document.save
    flash[:success] = "Document has been uploaded succesfully."

    redirect '/documents'
  else
    flash[:error] = "The document couldn't be uploaded because "
    flash[:error] += @document.errors.map do |field, error|
      "#{field} #{error}"
    end.join(', ') + "."

    erb :documents_new
  end
end

get '/documents/download/:id' do
  @document = Document.where(_id: params[:id]).first
  halt 404 unless @document

  if @me.role == :customer
    halt 403 unless @document.user == @me
  elsif @me.role == :accountant
    halt 403 unless ([@me.username] + @me.users.map do |user|
      user.username
    end).include?(@document.user.username)
  end

  file = @grid.get(@document.file)

  headers('Content-Type' => file.content_type,
          'Content-Disposition' => "attachment; filename=\"#{file.filename}\"")

  while data = file.read(10240)
    response.write data
  end
end

get '/documents/delete/:id' do
  @document = Document.where(_id: params[:id]).first
  halt 404 unless @document

  if @me.role == :customer
    halt 403 unless @document.user == @me
  elsif @me.role == :accountant
    halt 403 unless ([@me.username] + @me.users.map do |user|
                       user.username
                     end).include?(@document.user.username)
  end

  @document.destroy
  flash[:success] = "The document has been deleted successfully."

  redirect '/documents'
end

get '/documents/edit/:id' do  
  @document = Document.where(_id: params[:id]).first
  halt 404 unless @document

  if @me.role == :customer
    halt 403 unless @document.user == @me
  elsif @me.role == :accountant
    halt 403 unless ([@me.username] + @me.users.map do |user|
                       user.username
                     end).include?(@document.user.username)
  end
  
  if @me.role == :admin
    @owners = User.all.to_a.map do |user|
      user.username
    end
  elsif @me.role == :accountant
    @owners = [@me.username] + @me.users.map do |user|
      user.username
    end
  else
    @owners = nil
  end

  erb :documents_edit
end

post '/documents/edit/:id' do  
  if @me.role == :customer
    owner = @me
  else
    owner = User.where(username: params[:owner]).first
    halt 404 unless owner
  end

  @document = Document.where(_id: params[:id]).first
  halt 404 unless @document

  if @me.role == :customer
    halt 403 unless @document.user == @me
  elsif @me.role == :accountant
    halt 403 unless ([@me.username] + @me.users.map do |user|
                       user.username
                     end).include?(@document.user.username)
  end
  
  if @me.role == :admin
    @owners = User.all.to_a.map do |user|
      user.username
    end
  elsif @me.role == :accountant
    @owners = [@me.username] + @me.users.map do |user|
      user.username
    end
  else
    @owners = nil
  end

  if @me.role != :customer
    halt 403 unless @owners.include? owner.username
  end
  
  @document.write_attributes(name: params[:name],
                             user: owner)

  if params[:file]
    old_file = @document.file
    @document.file = @grid.put(params[:file][:tempfile],
                               content_type: params[:file][:type],
                               filename: params[:file][:filename])
  end

  if @document.valid?
    @document.save
    @grid.delete old_file

    flash[:success] = "The document has been updated successfully."

    redirect '/documents'
  else
    flash[:error] = "The document couldn't be updated because "
    flash[:error] += @document.errors.map do |field, error|
      "#{field} #{error}"
    end.join(', ') + "."
    
    erb :documents_edit
  end
end

