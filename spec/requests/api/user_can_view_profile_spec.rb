RSpec.describe 'GET /api/users/:user_id', type: :request do
  let(:user) { create(:user, email: 'test-2@example.com') }
  let(:user_header) { user.create_new_auth_token }
  let!(:post) { create(:post, user_id: user.id) }

  describe 'successfully' do
    before do
      get "/api/users/#{user.id}",
        headers: user_header
    end

    it 'is expected to return a 200 status' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return a user email' do
      expect(response_json['user']['email']).to eq 'test-2@example.com'
    end

    it 'is expected to return the track of the post' do
      expect(response_json['user']['posts'][0]['track']).to eq 'MyTrack'
    end

    it 'is expected to return the description of the post' do
      expect(response_json['user']['posts'][0]['description']).to eq 'MyDescription'
    end
  end

  describe 'unsuccessfully' do
    before do
      get '/api/users/abc',
        headers: user_header
    end

    it 'is expected to return a 404 status' do
      expect(response).to have_http_status 404
    end

    it 'is expected to return an error message' do
      expect(response_json['message']).to eq "Couldn't find User with 'id'=abc"
    end
  end
end
