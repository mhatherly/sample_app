# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example User", email: "user@example.com") }
	
	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	
	it { should be_valid }
	
	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end
	
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	
	describe "when name is too long" do
	    before { @user.name = "a" * 51 } # note use of string multiply
	    it {  should_not be_valid }
	end 
	
	describe "when email format is invalid"
		it "should be invalid"  do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
		               foobar@bar_biz.com foo@bar+baz.com]
		#  this is my addition to test for spaces 
		addresses.push ("foo bar@baz.com")
		addresses.push ("foobar@ba z.com")
		
		addresses.each do |invalid_address|
			@user.email = invalid_address
			@user.should_not be_valid
		end
	end
	
	describe "when email format is valid"
		it "should be valid"  do
		addresses = %w[user@foo.COM A_US-ER@f.b.org frst1.lst@foo.jp
		               a+b@baz.cn]
		addresses.each do |valid_address|
			@user.email = valid_address
			@user.should be_valid
		end
	end
    
    describe "when email address is already taken" do 
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		
		it { should_not be_valid }
	end
    
    
end
