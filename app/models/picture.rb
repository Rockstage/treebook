class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  attr_accessible :caption, :description, :asset
  # :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at

  #unknown attribute asset is fixed with
  has_attached_file :asset, styles: {
    small: "360x240>", medium: "720x480>", hd: "1280x720>", fullhd: "1920x1080>"
  }
  #:path => ':rails_root/public:url',
  #:url => '/:class/:attachment/:id_partition/:style/:filename'
  #:path => ":rails_root/public:url"
  #:url => "/public/system/assets/:id/:style/:basename.:extension",
  #:path => ":rails_root/public/system/assets/:id/:style/:basename.:extension"
  #:url => "/:attachment/:id/:style/:basename.:extension",
  #:path => ":rails_root/public/:attachment/:id/:style/:basename.:extension"

  validates_attachment_presence :asset
  validates_attachment_size :asset, :less_than => 5.megabytes
  validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  # small: "360x240>", medium: "720x480", hd: "1280x720", fullhd: "1920x1080"
  # small - Activity feed and album grids
  # medium - Album covers and other content
  # hd
  # fullhd

  #validates_attachment_size :asset, :less_than => 7.megabyte, message: 'You can upload up to 3MB for an Avatar.'
  #validates_attachment_content_type :asset, :content_type => ['image/jpeg', 'image/png', 'image/gif'], 
  #                                  message: 'You can only upload jpeg, png and gif images.'



  #validates :asset, attachment_presence: true

  def to_s
  	caption? ? caption : "Current Picture"
  end


end
