class Admins::AlarmsController < Admins::ApplicationController
  def new
    @user = User.find(params[:user_id])
    @alarm = @user.alarms.build
  end

  def create
    @user = User.find(params[:user_id])
    @alarm = @user.alarms.build(alarms_params)
    if @alarm.save
      redirect_to admins_user_path(@user), notice: '点呼が作成されました。'
    else
      render :new, status: :unprocessable_entity, alert: '点呼の作成に失敗しました。'
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @alarm = @user.alarms.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @alarm = @user.alarms.find(params[:id])
    if @alarm.update(alarms_params)
      redirect_to admins_user_path(@user), notice: '点呼が更新されました。'
    else
      render :edit, status: :unprocessable_entity, alert: '点呼の更新に失敗しました。'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @alarm = @user.alarms.find(params[:id])
    @alarm.destroy
    redirect_to admins_user_path(@user), notice: '点呼が削除されました。'
  end

  private

  # 点呼のストロングパラメータ
  def alarms_params
    params.require(:alarm).permit(
      :time, :title, :label, :everyday,
      :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday,
      :email, :line, :enabled
    )
  end
end
