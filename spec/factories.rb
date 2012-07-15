FactoryGirl.define do 
	factory :user do
		name		"Micheal Hartl" 
		email		"michael@example.com"
		password	"foobar"
		password_confirmation "foobar"
	end
end
