class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  helper_method :admin_signed_in?, :current_admin

  def authenticate_admin!
    unless admin_signed_in?
      redirect_to admins_login_path, alert: "ログインが必要です。"
    end
  end

  def admin_signed_in?
    session[:admin_id].present? && session[:admin_id] == "admin"
  end

  def current_admin
    return unless admin_signed_in?
    # Simple object to mimic Devise's current_admin
    OpenStruct.new(email: ENV["ADMIN_EMAIL"] || "admin@example.com")
  end


  # 本番環境でのみ、きちんと例外をキャッチし、エラーページを表示できるようにする
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if Rails.env.production?
      render file: "#{Rails.root}/public/422.html", status: :unprocessable_entity
    else
      raise exception
    end
  end

  rescue_from ActionController::UnknownFormat do |exception|
    if Rails.env.production?
      render file: "#{Rails.root}/public/422.html", status: :not_acceptable
    else
      raise exception
    end
  end

  rescue_from ActionController::RoutingError do |exception|
    if Rails.env.production?
      render file: "#{Rails.root}/public/404.html", status: :not_found
    else
      raise exception
    end
  end

  rescue_from ActionView::MissingTemplate do |exception|
    if Rails.env.production?
      # Force format to HTML, because we don't have error pages for other format requests.
      request.format = "html"
      render file: "#{Rails.root}/public/404.html", status: :not_found
    else
      raise exception
    end
  end
end
