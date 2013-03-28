class UserFriendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  # Cant Mass assign protected attributes fixed below
  attr_accessible :user, :friend, :user_id, :friend_id
end
