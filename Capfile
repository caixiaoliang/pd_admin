require "capistrano/setup"
require 'capistrano/deploy'
require 'capistrano/rbenv'
require 'capistrano/rails/migrations'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/puma'
# To use Git
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma  # Default puma tasks
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
