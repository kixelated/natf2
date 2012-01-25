class Stream < ActiveRecord::Base
  
  attr_accessible :title, :provider, :identifier, :viewers, :live, :description, :status
  belongs_to :user
  validates_presence_of :title, :provider, :identifier
  
  PROVIDERS = { "TwitchTV" => "justintv", "own3D.tv" => "own3dtv" }

  validates_inclusion_of :provider, :in => PROVIDERS.values

  def update_status
    if self.provider == "justintv"
      response = HTTParty.get("http://api.justin.tv/api/stream/list.xml?channel=#{identifier}")
      current_viewers = response["streams"]["stream"]["channel_count"] rescue nil
      current_status = response["streams"]["stream"]["channel"]["status"] rescue nil
      self.update_attributes(:viewers => current_viewers, :live => !!current_viewers, :status => current_status)
    elsif self.provider == "own3dtv"
      response = HTTParty.get("http://api.own3d.tv/liveCheck.php?live_id=#{identifier}")
      current_viewers = response["own3dReply"]["liveEvent"]["liveViewers"] rescue nil
      is_live = response["own3dReply"]["liveEvent"]["isLive"] rescue false
      self.update_attributes(:viewers => current_viewers, :live => is_live)
    end
  end

end
