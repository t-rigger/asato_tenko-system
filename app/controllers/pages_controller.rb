class PagesController < ApplicationController
  # Public page by default since ApplicationController doesn't enforce auth

  def qr_display
    render layout: false
  end
end
