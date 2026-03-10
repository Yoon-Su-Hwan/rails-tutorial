class AccountActivationsController < ApplicationController
  allow_unauthenticated_access

  def edit
    user = User.find_by(email_address: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      start_new_session_for user
      redirect_to root_path, notice: "アカウントが有効化されました！"
    else
      redirect_to root_path, alert: "無効な有効化リンクです。"
    end
  end
end
