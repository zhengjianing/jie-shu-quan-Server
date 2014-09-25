class User < ActiveRecord::Base

  belongs_to :group

  validates_presence_of :email
  validates_presence_of :password

  validates_uniqueness_of :email
  validates_format_of  :email, :message => "email format not correct!", :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

end
