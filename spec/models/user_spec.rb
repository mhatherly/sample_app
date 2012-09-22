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
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#

require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example User", email: "user@example.com",
	password: "foobar", password_confirmation: "foobar") }
	
	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }
    it { should respond_to(:relationships) }
    it { should respond_to(:followed_users) }
    it { should respond_to(:reverse_relationships) }
    it { should respond_to(:following?) }
    it { should respond_to(:follow!) }
    it { should respond_to(:unfollow!) }

	
	
	it { should be_valid }
	it { should_not be_admin }
	
	describe "when name is not present" do
		before { @user.name = " " }
		it { should_not be_valid }
	end
	
	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end
	
	describe "when email is nil" do
		before { @user.email = nil}
		it { should_not be_valid }
	end
	
	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end
	
	
	describe "when name is too long" do
	    before { @user.name = "a" * 51 } # note use of string multiply
	    it {  should_not be_valid }
	end 
	
	describe "when email format is invalid" do
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
	end
	
	describe "when email format is valid" do
			it "should be valid"  do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst1.lst@foo.jp
			               a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
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
	
	describe "when email address has mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPLe.CoM" }
		
		it "should be saved as all lower case" do
			@user.email = mixed_case_email 
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
		end
	end
	
	describe "when password doesn't match confirmation " do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end
    
    describe "when password confirmation is nil " do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end
    
    describe "return value of authenticate method" do 
		before { @user.save } 
		let(:found_user) { User.find_by_email(@user.email) }
		
		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end 
    
		describe "with invalid password" do 
			let (:user_for_invalid_password) { found_user.authenticate("invalid") }
           
             it { should_not == user_for_invalid_password}
             specify { user_for_invalid_password.should be_false}
		end
   end
    
    describe "with a password that is too short" do
		before { @user.password = @user.password_confirmation = "a"*5 }
        it {should be_invalid}
    end
    describe "with admin attribute set to 'true' " do
		before { @user.toggle!(:admin) }
		
		it { should be_admin }
    end
    
    describe "remember token" do
       before { @user.save } 
       its(:remember_token) { should_not be_blank }
    end

    describe "micropost associations" do 
      before { @user.save }
      let!(:older_micropost) do 
        FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
      end
      let!(:newer_micropost) do 
        FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
      end
      
      it "should have the right microposts in the right order" do
        @user.microposts.should == [newer_micropost, older_micropost]
      end
      
      it "should destroy associated microposts" do
        microposts = @user.microposts
        @user.destroy
        microposts.each do |micropost|
          Micropost.find_by_id(micropost.id).should be_nil
        end
       end # should destroy
    
    
        describe "status:" do 
          let(:unfollowed_post) do
            FactoryGirl.create(:micropost, user:FactoryGirl.create(:user))
          end
          let(:followed_user) { FactoryGirl.create(:user) }
          before do
            @user.follow!(followed_user) 
            3.times { followed_user.microposts.create!(content: "Lorem Ipsum") }
          end

          its(:feed) { should include(newer_micropost) }
          its(:feed) { should include(older_micropost) }
          its(:feed) { should_not include(unfollowed_post) }
          its(:feed) do 
            followed_user.microposts.each do |micropost|
              should include(micropost)
            end
          end
        end #status
    end # micropost associations
    
    describe "accessible attributes" do # ex 9.1
      it "should not allow access to admin" do
        
        expect do
          new_user =  User.new(name: "Test Mass assign", 
							email: "testadmin@example.com" ,
							password: "foobar",
							password_confirmation: "foobar",
							admin: true )
        end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
     end   # no access to admin
   end #accessable attributes
   
   describe "following" do
     let(:other_user) { FactoryGirl.create(:user) }
     before do
       @user.save
       @user.follow!(other_user)
      end
     it { should be_following(other_user) }
     its (:followed_users) { should include(other_user) }
     
     describe "followed user" do
       subject {other_user}
       its(:followers)  { should include(@user) }
    end

     describe "and unfollowing" do
       before { @user.unfollow!(other_user) }
       it { should_not be_following(other_user) }
       its (:followed_users) { should_not include(other_user) }
     end
     
    describe "when followed user is deleted" do
      before  { other_user.destroy }
      describe "it should destroy associated relationships" do
         it { should_not be_following(other_user) }
         its (:followed_users) { should_not include(other_user) }
        end 
    end #when followed user is deleted
     
    describe "when following user is deleted" do
      before  { @user.destroy }
      describe "it should destroy associated relationships" do
          subject {other_user}
          its(:followers)  { should_not include(@user) }
       end 
     end #when followed user is deleted
   end # following
end
