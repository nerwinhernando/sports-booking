module SuperAdmin
  class AccountsController < SuperAdmin::ApplicationController
    def index
      @accounts = Account.order(:name).page(params[:page]).per(20)
    end

    def show
      @account = Account.find(params[:id])
      @users = @account.users.order(:role, :email)
      @venues = @account.venues.order(:name)
      @bookings = @account.bookings.order(created_at: :desc).limit(10)
    end

    def new
      @account = Account.new
    end

    def create
      @account = Account.new(account_params)

      if @account.save
        redirect_to super_admin_account_path(@account), notice: 'Account created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @account = Account.find(params[:id])
    end

    def update
      @account = Account.find(params[:id])

      if @account.update(account_params)
        redirect_to super_admin_account_path(@account), notice: 'Account updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @account = Account.find(params[:id])
      @account.destroy
      redirect_to super_admin_accounts_path, notice: 'Account deleted successfully.'
    end

    private

    def account_params
      params.require(:account).permit(:name, :subdomain, :owner_name, :owner_email,
                                     :phone, :address, :city, :province, :plan, :active)
    end
  end
end
