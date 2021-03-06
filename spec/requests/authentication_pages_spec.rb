require 'spec_helper'

describe "Authentication" do
  subject {page}
  
  describe "signin page" do
    before { visit signin_path }
    
    it { should have_selector('h1', text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
    it { should_not have_link('Profile')}
    it { should_not have_link('Settings')}
    it { should_not have_link('Sign out')}
  end
  
  describe "signin" do 
    before { visit signin_path }

    describe "with invalid information" do
        before { click_button "Sign in" }
    
        it { should have_selector('title', text: 'Sign in' ) }
        it { should have_error_message('Invalid') }
        describe "after visiting another home page" do
            before { click_link "Home" }
                it { should have_no_error_message }

        end
    end
    
    describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in(user) } # defined in support/utilities
            
        it { should have_selector('title', text: user.name) }
        
        it { should have_link('Users', href: users_path) }
        it { should have_link('Profile', href: user_path(user))  }
        it { should have_link('Settings', href: edit_user_path(user)) }
        it { should have_link('Sign out', href: signout_path) }
        
        it { should_not have_link('Sign in', href: signin_path) }
    end
  end
  
  describe "authorization" do
    describe "for non-signed in users" do
      let (:user) { FactoryGirl.create(:user) }
      
      describe "when attempting to visit a protected page" do
        
        before do
          visit edit_user_path(user)
          sign_in user
        end # before
        
        describe "after signing in" do
        
            it "should render the desired protected page " do
				page.should have_selector('title', text: 'Edit user')
			end # should render
			
			describe "when signing in again" do
			  before do
			    visit signin_path
			    sign_in user
			  end
			  
			  it "should render the default (profile) page" do
			    page.should have_selector('title', text: user.name)
			  end
			end # signing  in again
         end #after signing in
      end # attempting...

      describe "in the Users Controller" do
      
        describe "visiting the edit page" do
          before { visit edit_user_path(user) } 
          it { should have_selector('title', text: 'Sign in') }
        end # visiting the edit page
        
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end # submitting to update action
       
        describe "visiting the user index" do 
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
         end
         
         describe "visiting the following page" do
           before { visit following_user_path(user) }
           it { should have_selector('title', text: 'Sign in') }
         end
         
          describe "visiting the followers page" do
           before { visit followers_user_path(user) }
           it { should have_selector('title', text: 'Sign in') }
         end

        describe "attempting to visit the signup page when signed in" do
         before do 
            
            
            sign_in user
            visit signup_path
         end 
         it { should have_selector('h1', text: user.name) } # home page 
        end # attempting to visit the signup pagen

        describe "attempting to delete yourself" do
         let(:dumb_user) { FactoryGirl.create(:user, 
					email: "dumb@example.com", admin: true) }
		
         before do 
		  sign_in dumb_user
          delete user_path(dumb_user)
         end 
 
         specify { response.should redirect_to(user_path) }
        end # attempting to delete
 
       end # in the users controller
      
      describe "in the Microposts controller" do
        
        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end # submitting to create

        describe "submitting to the destroy action"  do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end # submitting to destroy
      end # in the Micropost controller
	
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path } 
          specify { response.should redirect_to(signin_path) }
        end # create
        
        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }
        end # destroy
      end #in the Relationships controller
    end # non-signed in user

    describe "as wrong user" do 
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user,  email: "wrong@example.com") }
      before { sign_in user }
      
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end # visiting user edit
      
      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }  # goes to signon
      end # PUT request
    end #as wrong user

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      
      before { sign_in non_admin }
      
      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) } 
        
      end  # subm DELETE
    end # non admin user
    
  end # authorization
end # authentication
