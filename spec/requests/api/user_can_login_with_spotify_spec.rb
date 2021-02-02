# frozen_string_literal: true
RSpec.describe 'GET /omniauth/spotify', type: :request do
  subject { response }
  let(:headers) { subject.headers }
  let(:json) { response_json }
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:spotify] = OmniAuth::AuthHash.new(OmniAuthFixtures.spotify_response)
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:session)
      .and_return('dta.omniauth.auth': OmniAuth.config.mock_auth[:spotify])
  end
  describe 'WITH "resource_class" in params' do
    before do
      Rails.application.env_config['omniauth.params'] = { 'resource_class': 'User' }
      get '/auth/spotify/callback'
    end

    it 'is expected to responde with http status 200' do 
      is_expected.to have_http_status 200
    end

    it 'is expected to responde with key user and spotify_info' do
      expect(json)
        .to have_key('data')
        .and have_key('oauth_info')
        .and have_key('message')      
    end

    it 'is expected to return oauth data' do
      expect(json['oauth_info'])
        .to have_key('name')
        .and have_value('Lara Thordardottir')
        .and have_key('email')
        .and have_value('lara@fakemail.com')
    end

    it 'is expected to have valide headers' do
      expect(headers)
        .to have_key('access-token')
        .and have_key('client')
        .and have_key('token-type')
        .and have_key('expiry')
        .and have_key('uid')
        .and have_key('oauth_credentials')      
    end

    it 'is expected to have valide spotify_credential headers' do
      expect(headers['oauth_credentials'])
        .to have_key('token')
        .and have_key('refresh_token')
        .and have_key('expires_at')
        .and have_key('expires') 
    end
  end

  describe 'WITHOUT "resource_class" in params' do
    before do
      Rails.application.env_config['omniauth.params'] = { }
      get '/auth/spotify/callback'
    end

    it 'is expected responde with http status 200' do
      is_expected.to have_http_status 200
    end

    it 'is expected to responde with key user and spotify_info' do
      expect(json)
        .to have_key('data')
        .and have_key('oauth_info')
        .and have_key('message')
    end
  end
end
