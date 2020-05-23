class Api::PostsController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create
        post = Post.create(post_params)
        if post.save
            render json: { post: post }, status: :ok
        else
            render json: post.errors, status: :unprocessable_entity
        end
    end

    def index
        if params["title"].blank?
            posts = Post.all.order(created_at: :desc)
        else
            posts = Post.search(params["title"])
        end
        render json: { posts: posts }, status: :ok
    end

    def show
        post = Post.find(params[:id])
        render json: { post: post }, status: :ok
    end

    def destroy
        Post.find(params[:id]).destroy
        render json: { message: "Successfully deleted!"}, status: 200
    end

    def update
        Post.find(params[:id]).update(post_params)
        render json: { message: "Successfully edited!" }, status: 200
    end

    private
    def post_params
        params.require(:post).permit(:title, :description, :user_id)
    end
end