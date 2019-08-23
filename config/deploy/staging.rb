set :branch, 'develop'
set :deploy_to, '/var/www/pd_admin/staging'
set :bundle_flags, "--no-binstubs"
set :rails_env, 'production'
set :log_level, :debug
set :branch, 'develop'
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets bundle  public/assets public/uploads public/projects}
set :linked_files, %w{.env config/database.yml }
server '45.76.67.25',port: 22, user: 'deploy', roles: %w{web app db}
