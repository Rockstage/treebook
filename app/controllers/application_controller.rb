class ApplicationController < ActionController::Base
  protect_from_forgery


  private

  # Designed to handle a permission error in statuses controller test when updating statuses (line ~100)
  # Error was can't mass assign protected attributes, now it is redirecting to the error page
  def render_permission_error
  	render file: 'public/permission_error', status: :error, layout: false
  end



end
