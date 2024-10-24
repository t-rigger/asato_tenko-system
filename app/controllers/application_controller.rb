class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

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
