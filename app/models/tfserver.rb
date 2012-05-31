class Tfserver < ActiveRecord::Base

	attr_accessible :title, :servertitle, :ip, :port, :gametype, :players, :players_list, :max_players, :map
	belongs_to :user
	validates_presence_of :title, :ip


	def perform
		server = SourceServer.new(IPAddr.new(self.ip), self.port)
		serverinfo = server.server_info
		begin
			new_players = server.players.length
			new_maxplayers = serverinfo["max_players"]
			new_map = serverinfo["map_name"]
			new_servertitle = serverinfo["server_name"]
			
			playersList = ""
			for player in server.players.keys
				playersList = playersList + player + "%"
			end
			
			if serverinfo["game_description"].include? "SOAP"
				new_type = "DM"
			elsif serverinfo["game_description"].include? "MGE"
				new_type = "MGE"
			else
				new_type = ""
			end

		rescue Exception => e
			logger.error e
		ensure
			logger.info "#{ title }: #{ new_players }"
			self.update_attributes(:players => new_players, :max_players => new_maxplayers, :map => new_map, :servertitle => new_servertitle, :players_list => playersList, :gametype => new_type)
		end
	end
end

