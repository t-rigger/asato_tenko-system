class Admins::DashboardsController < Admins::ApplicationController

  def index
    @users = User.latest
    @alarms = Alarm.enabled_alarms
  end
end
