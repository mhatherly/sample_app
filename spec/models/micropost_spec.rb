require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) } 
  before do  #code is wrong
    @micropost = user.microposts.build(content: "Lorem ipsum") 
  end
  subject { @micropost }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  
  
  it { should be_valid }
  
  describe "when user_id is not present"  do
    before { @micropost.user_id =  nil }
    
    it { should_not be_valid }
  end
   
   describe "accessible attributes" do 
     it "should not allow access to user id " do 
       expect do
         Micropost.new(user_id: user.id) 
       end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
     end  # should not allow
   end # accessible attributes
 end
# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

