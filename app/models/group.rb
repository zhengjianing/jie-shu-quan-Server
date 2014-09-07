class Group < ActiveRecord::Base

  has_many :users

  validates_presence_of :group_name
  validates_uniqueness_of :group_name

end
