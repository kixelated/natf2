require 'omniauth-steam'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :steam
end