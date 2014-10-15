namespace :server do

  desc "Clear the previous server instance clutter."
  task :cleanup => :environment do
    pidfile = 'tmp/pids/server.pid'
    if File.exists? pidfile
      pid = File.read(pidfile).to_i
      if RbConfig::CONFIG['host_os'] =~ /mswin32/
        sh "taskkill /f /pid #{pid}"
        sh "del tmp\\pids\\server.pid"
      else
        sh "kill #{pid}"
        sh "rm #{pidfile}"
      end
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
