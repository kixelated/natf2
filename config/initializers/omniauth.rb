require 'omniauth-steam'

Rails.application.config.middleware.use OmniAuth::Builder do
  require 'openid/fetchers'
  OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"
  provider :steam
end