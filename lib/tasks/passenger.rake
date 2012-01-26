namespace :passenger do
  desc "Restart Application"
  task :restart do
    puts `touch tmp/restart.txt`
  end
end
