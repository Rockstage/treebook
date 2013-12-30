class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_user

  def show
  	if @user 
  		@statuses = @user.statuses.all
      @status ||= Status.new
		  @activities = @user.activities.all
      # Shows all activity by the @user
  		render action: :show
  	else
  		render file: 'public/404', status: 404, formats: [:html]
  	end
  end

  def stream
    if @user 
      @statuses = @user.statuses.all
      @status ||= Status.new
      @activities = Activity.for_user(current_user, params)
      # Shows all activity including friends' activity
      render action: :stream
    else
      render file: 'public/404', status: 404, formats: [:html]
    end
  end

  def player
    
  end

  def about_me
    if @user 
      @statuses = @user.statuses.all
      @activities = @user.activities.all
      render action: :about_me
    else
      render file: 'public/404', status: 404, formats: [:html]
    end
  end

  private
  def find_user
    @user = User.find_by_profile_name(params[:id])
  end

end
