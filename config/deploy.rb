set :repo_url,        'git@github.com:innovationfeel/maoli.git'
set :user,            'maoli'
set :application,     'maoli'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord

set :rvm_ruby_version, '2.3.1@maoli'

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{public/uploads}

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  # desc "Create config files from examples"
  # task :init_config_files do
  #   on roles(:app) do
  #     execute "cp #{deploy_to}/database.yml #{release_path}/config/database.yml"
  #     execute "cp #{deploy_to}/secrets.yml #{release_path}/config/secrets.yml"
  #     execute "cp #{deploy_to}/settings.yml #{release_path}/config/settings.yml"
  #   end
  # end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,       :check_revision
  # before :compile_assets, :init_config_files
  after  :finishing,      :compile_assets
  after  :finishing,      :cleanup
  after  :finishing,      :restart
end

# namespace :rakes do
#   desc 'Run a task on a remote server.'
#   # run like: cap production rakes:invoke task=my_task
#   task :run do
#     on roles(:app) do
#       rails_env = fetch(:rails_env, 'production')
#       # execute "cd '#{deploy_to}/current'; RAILS_ENV=#{rails_env} bundle exec rake #{ENV['task']}"
#       # invoke "cd '#{deploy_to}/current'"
#       invoke "bundle exec rake #{ENV['task']}"
#     end
#   end
# end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
