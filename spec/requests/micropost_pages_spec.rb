require 'spec_helper'

describe "Micropost pages" do
  subject { page }
  
  let(:user) {FactoryGirl.create(:user) }
  before {sign_in user}
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      
      it "should not create a micropost" do
         expect { click_button "Post" }.should_not change(Micropost, :count)
      end   
       
      describe "error messages" do
        before {  click_button "Post" }
        it { should  have_error_message("Content can't be blank")  }
       end    
    end # invalid information
    
    describe "with valid information" do
     
      before { fill_in 'micropost_content',  with: "Lorem ipsum" }
    
      it "should create a micropost" do
        expect { click_button "Post" }.should change(Micropost, :count).by(1)
      end 
      describe "with a single post" do
        before { click_button "Post" }
      
        it { should have_content "1 micropost" } # note singular
        it { should_not have_content "1 microposts" }
      end  
       describe "with multiple posts" do
         before do
           click_button "Post" 
           fill_in 'micropost_content',  with: "dolor sictus" 
           click_button "Post"
        end
           it { should have_content "2 microposts" } 
           # this works but is not useful 
           it { should have_xpath('/html/body/div/div[2]/aside/section/span[2]') }
           #within(xpath: '/html/body/div/div[2]/aside/section/span[2]') do
               #page.should have_content( "2 microposts" ) BAD
           #end
           #page.find(xpath: '/html/body/div/div[2]/aside/section/span[2]').
            #should have_content("2 microposts")  # BAD No method
            #it { find(xpath: '/html/body/div/div[2]/aside/section/span[2]').
            #should have_content("2 microposts") } # cant convert nil to string
            # added an id in the html so I can find this.
            it { should have_selector("span",  id: "post-count", text: "2 microposts") }
             it { should have_selector("#post-count", text: "2 microposts") }
       end 
    end # with valid information 
  end #micropost creation 
  describe "Micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before {visit root_path} 
      
      it "should delete a micropost" do
        expect { click_link "delete" }.should change(Micropost, :count).by(-1)
      end # should delete a micropost 
    end # as correct user    
  end # Micropost destruction
  
   describe "Micropost pagination" do
    describe "with only a few posts" do
        before  do
            2.times { FactoryGirl.create(:micropost, user: user) }
            visit root_path 
        end
         it { should_not  have_selector(".pagination") }
    end # "with only a few posts" 
     describe "with 50 posts" do
        before  do
            50.times { FactoryGirl.create(:micropost, user: user) } 
            visit root_path 
        end
         # looking for the class = pagination
         it { should have_selector(".pagination") }
       
         
    end # "with 50 posts" 
      
  end # Micropost pagination
  
  
  describe "viewing another user's microposts"  do
      let (:user2) { FactoryGirl.create(:user , 
                    email: "otheruser@somewhere.org" ,
                    name: "Other Guy")  }
      before do 
          #creates some posts for user2
          FactoryGirl.create(:micropost, user: user2,
                             content: 'Undeleteable - no delete tag')
          FactoryGirl.create(:micropost, user: user2)
                                               
          
          # navigate to that users profile page
          visit user_path(user2) 
      end
      # validate that we are on that page
      it { should have_content(user2.name) }   
      # find those posts
      it { should have_selector("li", text: "Undeleteable" ) }
      # validate that there is no link to delete.
      it { should_not have_link("delete") }
  end  # viewing another users microposes
end
