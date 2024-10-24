class Api::AlarmsController < Api::ApplicationController

  def update
    @user = User.find(params[:user_id])
    @alarm = @user.alarms.find(params[:id])
    if @alarm.update(enabled: params[:enabled])
      redirect_to admins_user_path(@user), notice: '点呼が更新されました。'
    else
      render :edit, status: :unprocessable_entity, alert: '点呼の更新に失敗しました。'
    end
  end
end
