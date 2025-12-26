module SuperAdmin
  class UsersController < SuperAdmin::ApplicationController
    def index
      @users = User.includes(:account)
                  .order(:role, :email)
                  .page(params[:page])
                  .per(50)
      
      # Apply filters
      @users = @users.where(role: params[:role]) if params[:role].present?
      @users = @users.where(account_id: params[:account_id]) if params[:account_id].present?
    end

    def show
      @user = User.find(params[:id])
      @bookings = @user.bookings.order(created_at: :desc).limit(10)
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        redirect_to super_admin_user_path(@user), notice: 'User updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, 
                                  :role, :active, :account_id, :player_type, :skill_level)
    end
  end
end
