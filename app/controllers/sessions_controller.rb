
class SessionsController < ApplicationController

   def new
   end
   
   def create 
      user =  User.find_by_email(params[:session][:email])
      if user && user.authenticate(params[:session][:password]) 
         #sign in the user and redirect to the user show page
         sign_in user
         redirect_to user
      else
          # Create an error message and re-render the signin form
          flash.now[:error] = 'Invalid email/password combination' 
          render 'new'
      end
   end
   
   def destroy
     sign_out
     redirect_to root_path
   end
   
end
