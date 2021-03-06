class UserNotifier < ActionMailer::Base
  default from: "no-reply@rockstage.org"

#We define the method - each method has an action and an associated view
  def friend_requested(user_friendship_id)
  	#Then we find the user friendship
  	user_friendship = UserFriendship.find(user_friendship_id)

  	#We set up variables to work with in the view
  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @friend.email,
  		subject: "#{@user.first_name} wants to be friends on Rockstage!"
  end


  def friend_request_accepted(user_friendship_id)
    user_friendship = UserFriendship.find(user_friendship_id)

    @user = user_friendship.user
    @friend = user_friendship.friend

    mail to: @user.email,
      subject: "#{@friend.first_name} has accepted your friend request on Rockstage!"
  end


end
