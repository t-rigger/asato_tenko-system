class Api::AlarmsController < ApplicationController
  before_action :authenticate_admin!
end
