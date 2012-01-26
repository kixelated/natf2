desc "This task is called by the Heroku scheduler add-on"
task :update_streams => :environment do
	puts "Updating streams..."
	@streams = Stream.all
	@streams.each do |s|
		s.update_status
	end
	puts "done."
end
