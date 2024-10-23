class Admins::DashboardsController < Admins::ApplicationController

  def index
    @users = User.latest
    @alarms = Alarm.enabled
  end
end
