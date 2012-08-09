include ApplicationHelper

# note Utilities are auto included in Rspec tests because they are in
# the spec/support directory

def valid_signin(user) 
	fill_in "Email",  with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
end

# Some other sources says that custom RSPEC matchers s/b in their own subdir
# withing the support directory, but we will include it here per Hartl

Rspec::Matchers.define :have_error_message do |message|
	match do |page|
	  page.should have_selector('div.alert.alert-error', text: message)
	end
end
