class Api::V1::LogsController < ApplicationController
    def index
        @logs = Log.joins(activity: :container).where("container_id = ?", params[:id])
        render json: @logs
    end
end
