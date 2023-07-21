class Api::V1::CommentsController < ApplicationController

    def index 
        @comments = Container.find(params[:id]).comments
        render json: @comments
    end

    def create
        @comment = Container.find(params[:id])&.comments.create!(create_comments_params)
        response = ActiveModelSerializers::SerializableResource.new(@comment, 
            {serializer: CommentSerializer}).as_json
        render json: response, status: :created  if @comment 
    end

    private

    def create_comments_params
        params.require(:comment).permit(:body, :user_id)
    end
end