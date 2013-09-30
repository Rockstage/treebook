class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, 
                  :profile_name, :avatar, :role, :location, :background,
                  # PERSONAL
                  :birthday, :gender, :relationship, 
                  :about, :music, :character, :interests,
                  # ARTIST
                  :artist_name, :genre, :bio, :members, :influence, :soundslike, :contacts

  # attr_accessible :title, :body

  # validates :first_name, presence: true, length: { :maximum => 50 }

  # validates :last_name, presence: true, length: { :maximum => 50 }

  validates :email, presence: true, uniqueness: true

  validates :profile_name, presence: true, 
            uniqueness: true,
            format: {
              with: /\A[a-zA-Z0-9_-]+\z/,
              message: 'Use can only use a-z, A-Z, 0-9, - and _'
            }

  validates :role, presence: true

  # validates :gender, presence: true

  # validates :age, presence: true, length: '> 13' or something similar

  has_many :authentications
  has_many :activities
  has_many :albums
  has_many :pictures
  has_many :statuses
  has_many :user_friendships
  has_many :friends, through: :user_friendships,
                              conditions: { user_friendships: { state: 'accepted' } }

  has_many :pending_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'pending' }
  has_many :pending_friends, through: :pending_user_friendships, source: :friend
  
  has_many :requested_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'requested' }
  has_many :requested_friends, through: :requested_user_friendships, source: :friend
  
  has_many :blocked_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'blocked' }
  has_many :blocked_friends, through: :blocked_user_friendships, source: :friend
  
  has_many :accepted_user_friendships, class_name: 'UserFriendship',
                                      foreign_key: :user_id,
                                      conditions: { state: 'accepted' }
  has_many :accepted_friends, through: :accepted_user_friendships, source: :friend

  # If changing styles do the rake task to clean up
  has_attached_file :avatar, styles: {
    thumb: "80x80#", avatar: "300x300#"
  }
  validates_attachment_size :avatar, :less_than => 3.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  has_attached_file :background, styles: {
    mobile: "1136x640>", desktop: "1920x1080>"
  }
  validates_attachment_size :background, :less_than => 7.megabytes
  validates_attachment_content_type :background, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  # Deletes all associated objects - statuses, albums, pictures
  after_destroy :delete_associations

  def default_avatar
    "avatar.png"
  end

  # Setting up a constant for user roles without admins and moderators
  ROLES = %w[person artist other]
  GENDER = %w[male female]

  # Remove this when setting default avatars and the associated rake task
  #def self.get_gravatars
  #  all.each do |user|
  #    if !user.avatar?
  #      # user.avatar = URI.parse(user.gravatar_url)
  #      user.avatar = 'images/avatar.png'
  #      user.save
  #      print "."
  #    end
  #  end
  #end
  #URI.prase tells paperclip to fetch a URI instead of the returned string


  # Also add if user is friends to show full name, otherwise profile name
  def full_name
    if role == "person"
      if first_name && last_name
    	first_name + " " + last_name
      else
      profile_name
      end
    elsif role == "artist"
      if artist_name
        artist_name
      else
        profile_name
      end
    elsif role == "other"
      profile_name
    end
  end

  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  #to param method helps when link to various locations
  def to_param
    profile_name
  end

  #overriding the to_string method helps us properly show first name in the string of the breadcrumbs
  def to_s
    first_name
  end

  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
  #strip removes any unneeded space
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end


  # OMNIAUTH Authentications Controller methods
  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
    :uid => omni['uid'],
    :token => omni['credentials'].token,
    :token_secret => omni['credentials'].secret)
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super #&& provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end




  def create_activity(item, action)
    # This will be scoped automatically to the user instance
    activity = activities.new
    activity.targetable = item
    activity.action = action
    activity.save
    # The create_activity method returns the actual activity instance
    activity
  end

  private

  def delete_associations
    self.statuses.destroy_all
    self.albums.destroy_all
    self.activities.destroy_all
    self.user_friendships.destroy_all
    self.authentications.destroy_all
  end
  
end
