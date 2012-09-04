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
  
end # Micropost pages
