class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :type, :password_confirmation, :committee, :position)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :type, :password_confirmation, :committee, :position, :current_password)
  end
  
end