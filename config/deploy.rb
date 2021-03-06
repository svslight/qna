# config valid for current version and patch releases of Capistrano
lock "~> 3.12.0"

set :application, "qna"
set :repo_url, "git@github.com:Rick-ROR/qna.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/data/www/qna"
set :deploy_user, "deployer"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure


# adding "deployer    ALL=(ALL)  NOPASSWD: ALL" after line start with "%sudo" in sudo visudo
# create service in /etc/systemd/user/sidekiq.service
set :init_system, :systemd
set :service_unit_name, "sidekiq"

# не работает. capistrano всё равно запускает unicorn с опцией -E deployment, впрочем на работе не сказывается.
set :unicorn_env, "production"
set :rails_env, "production"

after 'deploy:publishing', 'unicorn:restart'
