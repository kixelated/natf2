namespace :tf2_server do
  desc "Updates the current status for all of the servers"
  task :update => :environment do
    Tf2Server.all.each do |tf2_server|
      Delayed::Job.enqueue(tf2_server)
    end
  end
end
