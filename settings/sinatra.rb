use(Rack::Session::Memcache, namespace: 'document_foo',
    memcache_server: 'localhost:11211')
use Rack::Flash, sweep: true

set :public_folder, settings.root + '/static'
set :views, settings.root + '/views'
