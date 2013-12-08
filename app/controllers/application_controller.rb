class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  #rescue_from CanCan::AccessDenied do |exception|
    #render :nothing, :alert => exception.message
  #end

  # before_filter :prepare_for_mobile

  # Used to implemet page-specific actions such as adding specific css rules
  def page_code
  	0
  end

  # This is default.
  # Add the same action to a any controller to set the page_title acordingly
  def page_title
  	"Rockstage"
  end

  private

  # Designed to handle a permission error in statuses controller test when updating statuses (line ~100)
  # Error was can't mass assign protected attributes, now it is redirecting to the error page
  def render_permission_error
  	render file: 'public/permission_error', status: :error, layout: false
  end

  def render_404
    render file: 'public/404', status: :not_found
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end
