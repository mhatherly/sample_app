include ApplicationHelper

# note Utilities are auto included in Rspec tests because they are in
# the spec/support directory

def valid_signin(user) 
	fill_in "Email",  with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
end

def sign_in(user)
	visit signin_path
	fill_in "Email",  with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	# Sign in when not using Capybara as well
	cookies[:remember_toke] = user.remember_token
end

