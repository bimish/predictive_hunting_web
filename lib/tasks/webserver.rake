namespace :server do

  desc "Clear the previous server instance clutter."
  task :cleanup => :environment do
    pidfile = 'tmp/pids/server.pid'
    if File.exists? pidfile
      pid = File.read(pidfile).to_i
      puts 'found server.pid'
      sh "kill -9 #{pid}"
      sh "rm #{pidfile}"
      puts "All cleaned up. Yay!"
    else
      puts "Already clean. Whew!"
    end
  end

  desc "Start an instance of the server cleanly."
  task :start => :cleanup do
    sh "rails server"
  end

end
