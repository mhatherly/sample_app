# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
    attr_accessible :name, :email, :password, :password_confirmation
	
	has_secure_password


#    MH change to alternate form of downcasing as in exercise 6.2	
#	before_save { |user| user.email = email.downcase }
 	before_save { self.email.downcase! }  #better!
 	
 	
   validates :name, presence: true , length: { maximum: 50 }
   # note that this regex validates as a string not a line 
   # \A.\z are start and end
   VALID_EMAIL_REGEX  = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

   validates :email, presence: true, format: {with: VALID_EMAIL_REGEX },
					 uniqueness: { case_sensitive: false }
					 
#   presence removed to fix error message - now handled in UI: exercise 7.6.3
	validates  :password, length: { minimum: 6 }

   validates  :password_confirmation, presence: true
 end
