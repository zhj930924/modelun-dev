class UsersController < ApplicationController
  
  before_action :authenticate_user!

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def index
    
    @users = Delegate.where("committee= ?", current_user.committee).where.not("id = ?",current_user.id).order("created_at DESC").paginate(page: params[:page])
    
  end
  
  def new
    @user = User.new
  end

  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      # @user.send_activation_email
      flash[:info] = "Welcome to the sample application"
      redirect_to @user
    else
      render 'new'
    end
  end
  
#   def edit
#   end
  
  def delegate_personal_directive
    PersonalDirective.where("user_id IN (?) OR user_id = ?")
  end
  
  def show
    if user_signed_in?
      @user = User.find_by(id: params[:id])
      if @user[:type] == "Crisis"
        @feed_items = Resolution.all.paginate(page: params[:page])
      elsif @user[:type] == "Delegate"
        @feed_items = @user.personal_directives.paginate(page: params[:page])
      end
    else 
      redirect_to root_url
    end
  end
  
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Updated"
      redirect_to request.referer
    else
      render root_url
    end
    render root_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :type, :password_confirmation, :committee, :position, :claim, :quality)
    end
    
#     # Before filters
    
    
#     def correct_user
#       @user = User.find(params[:id])
#       redirect_to(root_url) unless current_user?(@user)
#     end
    
#     def admin_user
#       redirect_to(root_url) unless current_user.admin?
#     end
# end
end
