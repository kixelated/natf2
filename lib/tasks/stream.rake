namespace :stream do
  desc "Updates the current status for all of the streams"
  task :update => :environment do
    Stream.all.each do |stream|
      Delayed::Job.enqueue(stream)
    end
  end
end
