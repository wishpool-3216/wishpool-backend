Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_ID_WISHPOOL'], ENV['FACEBOOK_SECRET_WISHPOOL'],
           scope: 'email,user_birthday'
end
