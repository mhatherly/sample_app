
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update] # in sessions Helper
  before_filter :signed_out_user, only: [:new, :create]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :non_suicidal_user, only: [:destroy]
  before_filter :admin_user,   only: :destroy
  
  def show
	@user = User.find(params[:id])
	@microposts = @user.microposts.paginate(page: params[:page])
  end
  	
  def new
	@user = User.new
  end
  
  def create
    @user = User.new(params[:user])
  	if @user.save
		sign_in @user
		flash[:success] = "Welcome to the Sample App!"
		redirect_to @user
	else
		render 'new'
	end
  end 
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def edit
  end
  
  def update 
     if @user.update_attributes(params[:user]) 
        flash[:success] = "Profile updated"
        sign_in @user
        redirect_to @user
     else
		render 'edit'
	 end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
  

   def signed_out_user
     if signed_in?
		redirect_to root_path, 
			notice: 
		     "Please sign out if you want to add a new user" 
     end
  end
    def non_suicidal_user
     @user=User.find(params[:id]) 
     if current_user?(@user)
      redirect_to user_path, 
          error: "You cannot delete yourself" 
     end
   end
  
  def correct_user
    @user=User.find(params[:id]) 
    redirect_to(root_path) unless current_user?(@user)
   end
   
   def admin_user
    redirect_to(root_path) unless current_user.admin?
   end
end
