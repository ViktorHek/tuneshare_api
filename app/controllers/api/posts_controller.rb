class Api::PostsController < ApplicationController
  def index
    posts = Post.order('created_at DESC')
    render json: posts, each_serializer: PostIndexSerializer
  end

  def create
    post = current_user.posts.create(post_params)
    if post.persisted?
      render json: { message: 'Your post was successfully created!' }, status: 201
    else
      render json: { message: post.errors.full_messages.to_sentence }, status: 422
    end
  end

  def destroy
    Post.find(params[:post_id]).destroy!
    head :no_content
  rescue StandardError => e
    render json: { message: 'Oops, something went very wrong...' }, status: 404
  end

  private

  def post_params
    params.require(:post).permit(:track, :artists, :image, :preview, :description)
  end
end
