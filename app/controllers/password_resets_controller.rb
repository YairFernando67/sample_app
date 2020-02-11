class PasswordResetsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "An email has been sent to the specified email address with intructions to reset your password"
      redirect_to root_path
    else
      flash.now[:danger] = "The email address provided was not found"
      render :new
    end
  end

  def edit
  end
end
