class Admins::UsersController < Admins::ApplicationController

  def show
    @user = User.find(params[:id])
    @alarms = @user.alarms.latest
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update!(user_params)
      redirect_to admins_user_path(@user), notice: '登録情報を更新しました'
    else
      flash.now[:alert] = '登録情報の更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
