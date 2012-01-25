class Stream < ActiveRecord::Base
  
  attr_accessible :title, :provider, :identifier, :viewers, :live
  
  belongs_to :user
  
  validates_presence_of :title, :provider, :identifier
  
  def update_status
    if self.provider == "justintv"
      response = HTTParty.get("http://api.justin.tv/api/stream/list.xml?channel=#{identifier}")
      if response.has_key?("streams")
        current_viewers = response["streams"]["stream"]["channel_count"]
        self.update_attributes(:viewers => current_viewers, :live => true)
      else
        self.update_attributes(:viewers => nil, :live => false)
      end
    elsif self.provider == "own3dtv"
      response = HTTParty.get("http://api.own3d.tv/liveCheck.php?live_id=#{identifier}")
      if response.has_key?("own3dReply")
        current_viewers = response["own3dReply"]["liveEvent"]["liveViewers"]
        is_live = response["own3dReply"]["liveEvent"]["isLive"]
        self.update_attributes(:viewers => current_viewers, :live => is_live)
      else
        self.update_attributes(:viewers => nil, :live => false)
      end
    end
  end

end
