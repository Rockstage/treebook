require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
	should have_many(:friends)

	test "a user should enter a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:george).profile_name

		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a profile name without spaces" do
		#user = User.new
		#user.profile_name = "My Profile With Spaces"
		user = User.new(first_name: 'George', last_name: 'Petrov', email: 'jokopetrov@gmail.com')
		user.password = user.password_confirmation = 'jokojoko123'

		assert !user.save
		assert !user.errors[:profile_name].empty?
		assert user.errors[:profile_name].include?('Must be formatted correctly.')

	end

	test "a user can have a correctly formated profile name" do
		user = User.new(first_name: 'George', last_name: 'Petrov', email: 'jokopetrov@gmail.com')
		user.password = user.password_confirmation = 'jokojoko123'


		user.profile_name = "Test123_-"
		assert user.invalid?
	end

	test "that no error is raised when trying to access a friend list" do
		assert_nothing_raised do
			users(:george).friends
		end
	end

	test "that creating friendships on a user works" do
		users(:george).friends << users(:emilly)
		users(:george).friends.reload
		assert users(:george).friends.include?(users(:emilly))
	end

  # test "the truth" do
  #   assert true
  # end
end
