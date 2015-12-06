class UserssController < ApplicationController

  def index
    raise ActionController::RoutingError.new('Forbidden') if current_user.nil? || !current_user.has_role?("admin")
    @users = User.all
  end

end
