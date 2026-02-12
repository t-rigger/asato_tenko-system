class Admins::SessionsController < ApplicationController


  def new
    if admin_signed_in?
      redirect_to admins_dashboard_path, notice: "すでにログインしています。"
    end
  end

  def create
    admin_email = ENV['ADMIN_EMAIL'] || "admin@example.com"
    admin_password = ENV['ADMIN_PASSWORD'] || "password123"

    if params[:email] == admin_email && params[:password] == admin_password
      session[:admin_id] = "admin"
      redirect_to admins_dashboard_path, notice: "ログインしました。"
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path, notice: "ログアウトしました。", status: :see_other
  end
end

