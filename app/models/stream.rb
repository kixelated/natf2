class Stream < ActiveRecord::Base
  
  attr_accessible :title, :provider, :identifier, :viewers, :live, :description, :status
  belongs_to :user
  validates_presence_of :title, :provider, :identifier
  
  PROVIDERS = { "TwitchTV" => "justintv", "own3D.tv" => "own3dtv" }

  validates_inclusion_of :provider, :in => PROVIDERS.values

  def update_status
    current_viewers = nil
    current_status = nil
    is_live = false
    if self.provider == "justintv"
      response = HTTParty.get("http://api.justin.tv/api/stream/list.xml?channel=#{identifier}")
      begin
        current_viewers = response["streams"]["stream"]["channel_count"]
        current_status = response["streams"]["stream"]["channel"]["status"]
      rescue Exception => e
        logger.error e
      ensure
        self.update_attributes(:viewers => current_viewers, :live => !!current_viewers, :status => current_status)
      end
    elsif self.provider == "own3dtv"
      response = HTTParty.get("http://api.own3d.tv/liveCheck.php?live_id=#{identifier}")
      begin
        current_viewers = response["own3dReply"]["liveEvent"]["liveViewers"]
        is_live = response["own3dReply"]["liveEvent"]["isLive"]
      rescue Exception => e
        logger.error e
      ensure
        self.update_attributes(:viewers => current_viewers, :live => is_live)
      end
    end
  end

end
