class Api::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    comment = Comment.new(comment_params)
    if comment.save
      render json: { comment: comment }, status: :ok
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  def index
    @comments = Comment.where(post_id: params[:post_id]).order(created_at: :desc)
    render json: { comments: @comments }, status: :ok
  end

  private
  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :comment)
  end
end
