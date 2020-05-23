class Api::ClapsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        if has_user_already_clapped?
            render json: { message: "Cannot clap multiple times!" }, status: 405
        else
            clap = Clap.new(clap_params)
            clap.save ? (render json: {status: :ok}) : (render json: clap.errors, status: :unprocessable_entity)
        end
    end

    def index
        @claps = Clap.where(clapable_id: params[:clapable_id], clapable_type: params[:clapable_type])
        render json: { claps: @claps.count }, status: :ok
    end

    private
    def clap_params
        params.require(:clap).permit(:user_id, :clapable_id, :clapable_type)
    end

    def has_user_already_clapped?
        claps = Clap.where(user_id: params["clap"]["user_id"])
                    .where(clapable_id: params["clap"]["clapable_id"])
                    .where(clapable_type: params["clap"]["clapable_type"])
                    .count
        claps > 0 ? true : false
    end
end