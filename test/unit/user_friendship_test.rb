require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
	should belong_to(:user)
	should belong_to(:friend)

	test "that creating a friendship works without rasing an exception"  do
		assert_nothing_raised do
		UserFriendship.create user: users(:george), friend: users(:ivelina)
		end
	end

	test "that creating a friendship based on user id and friend id works" do
		UserFriendship.create user_id: users(:george).id, friend_id: users(:emilly).id
		assert users(:george).friends.include?(users(:emilly))
	end
end
