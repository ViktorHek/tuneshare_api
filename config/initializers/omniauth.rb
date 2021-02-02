# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify,
           Rails.application.credentials.spotify[:client_id],
           Rails.application.credentials.spotify[:client_secret],
           scope: 'user-read-email user-read-private playlist-modify-public user-library-read user-library-modify streaming'

  provider :facebook,
           Rails.application.credentials.facebook[:app_id],
           Rails.application.credentials.facebook[:app_secret],
           scope: 'email public_profile'
end
