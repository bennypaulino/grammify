class RegistrationsController < Devise::RegistrationsController


  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :remember_me)
  end

  def sign_in_params
    params.require(:user).permit(:login, :username, :email, :password, :remember_me)
  end

  def account_update_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :current_password)
  end

  def after_update_path_for(resource)
    user_path(resource)
  end

end