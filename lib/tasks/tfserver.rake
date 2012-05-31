namespace :tfserver do
  desc "Updates the current status for all of the servers"
  task :update => :environment do
    Tfserver.all.each do |tfserver|
      Delayed::Job.enqueue(tfserver)
    end
  end
end
