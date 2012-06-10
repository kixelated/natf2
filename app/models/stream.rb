class Stream < ActiveRecord::Base

  attr_accessible :title, :provider, :identifier, :viewers, :live, :description, :status
  belongs_to :user
  validates_presence_of :title, :provider, :identifier

  PROVIDERS = { "TwitchTV" => "justintv", "own3D.tv" => "own3dtv" }

  validates_inclusion_of :provider, :in => PROVIDERS.values

  def perform
    current_viewers = nil
    current_status = nil
    is_live = false

    jtv_key = Settings.justintv_consumer_key
    jtv_secret = Settings.justintv_secret_key
    jtv_consumer = OAuth::Consumer.new(jtv_key, jtv_secret,
                                   :site => "http://api.justin.tv",
                                   :http_method => :get)

    # make the access token from your consumer
    jtv_access_token = OAuth::AccessToken.new jtv_consumer


    if self.provider == "justintv"

      # make a signed request!
      response = ActiveSupport::JSON.decode(jtv_access_token.get("/api/stream/list.json?channel=#{identifier}").body)

      begin
        current_viewers = response[0]["channel_count"]
        current_status = response[0]["channel"]["status"]
      rescue Exception => e
        logger.error e
      ensure
        logger.info "#{ title }: #{ current_viewers }"
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
        logger.info "#{ title }: #{ current_viewers }"
        self.update_attributes(:viewers => current_viewers, :live => is_live)
      end
    end
  end
  
  def to_s
  	return title
  end

end
