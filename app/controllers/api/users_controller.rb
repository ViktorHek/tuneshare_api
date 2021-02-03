class Api::UsersController < ApplicationController
  def show
    user = User.find(params['id'])
    render json: user, serializer: UserShowSerializer
  rescue StandardError => e
    render json: { message: e.message }, status: 404
  end
end
