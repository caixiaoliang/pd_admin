# require 'sidekiq/capistrano'
# require 'capistrano/sidekiq'

lock "3.11.0"
set :application, "pd_admin"
set :repo_url, "ssh://git@github.com:caixiaoliang/pd_admin.git"

set :keep_releases, 5
set :rbenv_type, :user # :system or :user
set :rbenv_ruby, '2.3.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
# set :assets_prefix, "keyboard_classroom/aseets"

append :rbenv_map_bins, 'puma', 'pumactl'
