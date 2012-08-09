include ApplicationHelper

# note Utilities are auto included in Rspec tests because they are in
# the spec/support directory

def valid_signin(user) 
	fill_in "Email",  with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
end


