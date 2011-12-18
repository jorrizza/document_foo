Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('document_foo')
end
