namespace :stream do
  desc "Updates the current status for all of the streams"
  task :update => :environment do
    streams = Stream.all
    streams.each do |stream|
      puts "Updating stream: #{ stream.title } #{ stream.id }"
      stream.update_status
    end
  end
end
