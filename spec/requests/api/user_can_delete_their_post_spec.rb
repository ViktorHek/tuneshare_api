RSpec.describe 'DELETE /api/posts/:post_id', type: :request do
  let!(:post) { create(:post) }
  let(:user) { create(:user) }
  let(:user_header) { user.create_new_auth_token }
  describe 'successfully delete their post' do
    before do
      delete "/api/posts/#{post.id}",
             params: { post_id: post.id },
             headers: user_header
    end

    it 'is expected to return a 204 status' do
      expect(response).to have_http_status 204
    end

    it 'is expected to not return a post' do
      expect(response.body).to eq ''
    end
  end
end
