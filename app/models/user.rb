class User < ActiveRecord::Base

  validates_presence_of :user_name
  validates_presence_of :email
  validates_presence_of :password

  validates_uniqueness_of :email

end
