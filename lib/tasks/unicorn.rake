namespace :unicorn do

  rails_env = 'development'
  unicorn_pid = Rails.root.to_s + '/tmp/pids/unicorn.pid'

  desc "start unicorn"
  task :start do
    puts "Unicorn is starting"
    system "cd #{Rails.root} && bundle exec unicorn -c #{Rails.root}/config/unicorn.rb -E #{rails_env} -D"
  end

  desc "stop unicorn"
  task :stop do
    puts "Unicorn is stopping"
    system "kill `cat #{unicorn_pid}`"
  end

  desc "graceful stop unicorn"
  task :graceful_stop do
    puts "Unicorn is graceful stopping"
    system "kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "reload unicorn"
  task :reload do
    puts "Unicorn is reloading"
    system "kill -s USR2 `cat #{unicorn_pid}`"
  end

  desc "restart unicorn"
  task :restart do
    puts "Unicorn is restarting"
    Rake::Task['unicorn:stop'].execute
    Rake::Task['unicorn:start'].execute
  end
end
