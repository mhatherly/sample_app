
Rspec::Matchers.define :have_no_error_message do 
	match do |page|
	  page.should_not have_selector('div.alert.alert-error')
	end
end
