class ApplicationController < ActionController::API  
  # Doorkeeper code
  before_action :doorkeeper_authorize!

  include UserConcern
  include PaginationConcern
  include HelperConcern
  include ActionController::MimeResponds

  private
  # Doorkeeper methods
  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
