$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

require 'bundler/capistrano'

set :scm, :git
set :runner, "dylan"
default_run_options[:pty] = true

set :application, "jtv.dylanmarkow.com"
set :repository, "git@github.com:dmarkow/spell_check_mini_app --depth=1"
set :branch, "master"
set :scm_command, "/usr/bin/git"

set :deploy_to, "/var/www/#{application}"
role :app, "jtv.dylanmarkow.com"
role :web, "jtv.dylanmarkow.com"
role :db, "jtv.dylanmarkow.com", :primary => true

namespace :deploy do
  desc "Stop the server"
  task :stop, :roles => :app do
    puts "Not valid for phusion"
  end
  
  desc "Restart the server"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Start the server"
  task :start, :roles => :app do
    puts "Not valid for phusion"
  end
end

