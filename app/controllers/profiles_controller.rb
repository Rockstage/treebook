class ProfilesController < ApplicationController
  before_filter :find_user

  def show
  	if @user 
  		@statuses = @user.statuses.all
		  @activities = @user.activities.all
  		render action: :show
  	else
  		render file: 'public/404', status: 404, formats: [:html]
  	end
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
