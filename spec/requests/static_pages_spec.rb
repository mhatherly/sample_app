require 'spec_helper'



describe "StaticPages" do

#  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
   subject { page }		

  shared_examples_for "all static pages" do
	it { should have_selector('h1', text:  heading) }
	it { should have_selector('title', text: full_title(page_title)) } 
	it { should have_content (heading) } 
  
  end
  
  
  
  describe "Home page" do
	before {visit root_path}
	let (:heading) { 'Sample App' }
	let (:page_title) { '' }
    it_should_behave_like "all static pages"
	it {should_not have_selector 'title', text: '| Home'}
    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end
      
      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end # should render
      
    end # for signed in users
    
   end  # home page
  
  describe "Help page" do
    before {visit help_path}
    let (:heading) { 'Help' }
    let (:page_title) { heading }   # this is MH creativity
	it_should_behave_like "all static pages"	
  end

  describe "About page" do
	before {visit about_path}
	let (:heading) { 'About Us' }
	let (:page_title) { heading }
	it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
	before {visit contact_path}
	let (:heading) { 'Contact' }
    let (:page_title) { heading }
	it_should_behave_like "all static pages"
  end
#  The book has this here, but is it testing completely - yes   Perhaps
#  we can do something as a shared test
    it "should have the right links on the header and footer" do 
		visit root_path
		click_link "About"
		page.should have_selector 'title' , text: full_title("About Us")
	    click_link "Help"
		page.should have_selector 'title' , text: full_title("Help")
	    click_link "Contact"
		page.should have_selector 'title' , text: full_title("Contact")
	    # back to root path for link testing home page
	    click_link "Home"
		page.should have_selector 'title' , text: full_title("")
		click_link "Sign up now!"
		page.should have_selector 'title' , text: full_title("Sign up")
		click_link "sample app" 
		page.should have_selector 'title' , text: full_title("")
    end
end
