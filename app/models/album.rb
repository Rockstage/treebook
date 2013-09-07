class Album < ActiveRecord::Base
  belongs_to :user
  has_many :pictures
  attr_accessible :title
  after_destroy :cleanup


  private
  def cleanup
  	self.pictures.delete_all
  end
end
