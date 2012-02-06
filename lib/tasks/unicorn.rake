namespace :unicorn do

  rails_env = 'development'
  unicorn_pid = Rails.root.to_s + '/tmp/pids/unicorn.pid'

  desc "start unicorn"
  task :start do
    system "cd #{Rails.root} && bundle exec unicorn -c #{Rails.root}/config/unicorn.rb -E #{rails_env} -D"
    puts "Unicorn is start"
  end

  desc "stop unicorn"
  task :stop do
    system "kill `cat #{unicorn_pid}`"
    puts "Unicorn is stop"
  end

  desc "graceful stop unicorn"
  task :graceful_stop do
    system "kill -s QUIT `cat #{unicorn_pid}`"
    puts "Unicorn is graceful stop"
  end

  desc "reload unicorn"
  task :reload do
    system "kill -s USR2 `cat #{unicorn_pid}`"
    puts "Unicorn is reload"
  end

  desc "restart unicorn"
  task :restart do
    stop
    start
    puts "Unicorn is restart"
  end
end