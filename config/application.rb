# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

Bundler.require(*Rails.groups)

module TuneshareApi
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    config.generators do |generate|
      generate.helper false
      generate.assets false
      generate.view_specs false
      generate.helper_specs false
      generate.routing_specs false
      generate.controller_specs false
      generate.request_specs false
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3001', 'c99f0c11f54d.ngrok.io'
        resource '*',
                 headers: :any,
                 expose: %w[access-token expiry token-type uid client spotify_credentials],
                 methods: %i[get post put delete options],
                 max_age: 0
      end
    end
    config.hosts << 'tuneshare-2021.herokuapp.com'
    config.hosts << 'c99f0c11f54d.ngrok.io'
    config.action_dispatch.default_headers = {
      'Referrer-Policy' => 'no-referrer-when-downgrade',
      'X-Content-Type-Options' => 'nosniff',
      'X-Frame-Options' => 'SAMEORIGIN',
      'X-XSS-Protection' => '1; mode=block',
      'Access-Control-Allow-Origin' => 'localhost:3001',
      'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept'
    }
  end
end
