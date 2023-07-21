class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :doorkeeper_authorize!, expect: %i[sign_in, reset_password_by_token, update_password]

  def sign_in
    user = User.authenticate!(sign_in_params[:email], sign_in_params[:password])
    if user 
      render json: { Authorization: "Bearer #{generate_token(user).token}" }
    else
      render json: "user not present", status: :unauthorized
    end
  end

  def reset_password_token
    @user = User.find_by_email(params[:user][:email]&.downcase)

    if @user.present?
      render json: { reset_password_token: @user.send_reset_password_instructions}
    else
      render json: { error: "Couldn't able to find user with email #{params[:user][:email]}"}, status: :unauthorized
    end
  end

  def update_password
    @user = User.reset_password_by_token(update_password_params).id 

    unless @user 
      render json: { error: "Invalid password reset token" }, status: :unprocessable_entity
    else
      render json: { message: "password updated successfully" }, status: :ok
    end
  end

  def sign_out
    @token = Doorkeeper::AccessToken.find_by(token: request.headers['Authorization'])
    if @token and @token.destroy 
      render json: { message: "logout successfully"}
    else 
      render json: { error: "Invalid token" }
    end
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password).tap do |params|
      params.require(%i[email password])
    end
  end

  def update_password_params
    params.require(:password).permit(:reset_password_token, :password, :password_confirmation).tap do |params|
      params.require(%i[reset_password_token password password_confirmation])
    end
  end
end
