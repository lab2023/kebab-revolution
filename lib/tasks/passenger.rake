namespace :passenger do
  desc "Restart Application"
  task :restart do
    system `cd #{Rails.root} && touch tmp/restart.txt`
    puts "Passenger is restart"
  end
end
