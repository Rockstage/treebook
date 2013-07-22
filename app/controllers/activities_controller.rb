class ActivitiesController < ApplicationController
	before_filter :authenticate_user!
  # we need to index all of our and our friend's activities
  def index
  	# To collect all of the friend ids into an array we use the map method
  	# map will iterate through each object and return an array of ids [1, 2, 4, 8]
  	friend_ids = current_user.friends.map(&:id)

  	# @activities object is the Activity model where the user_id is in this array "(?)"
  	# the array is then passed "friend_ids" and the id of the current user is also pushed into the array
  	@activities = Activity.where("user_id in (?)", friend_ids.push(current_user.id)).order("created_at desc").all
    # Ensures that menus get updated when a user logs in since activities#index is root
    refresh_dom_with_partial('div#header', 'navbar')
    refresh_dom_with_partial('section#sidebar', 'sidebar')
  end
end
