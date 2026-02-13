class PagesController < ApplicationController
  before_action :authenticate_admin!, only: [:qr_display]

  def qr_display
    render layout: false
  end
end
