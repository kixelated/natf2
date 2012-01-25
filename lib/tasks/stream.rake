task "stream:update" => :environment do
	@streams = Stream.all
	@streams.each do |s|
		s.update_status
	end
end
