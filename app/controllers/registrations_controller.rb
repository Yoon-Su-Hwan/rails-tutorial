class RegistrationsController < ApplicationController
  # 로그인을 하지 않아도 회원가입은 가능해야 하므로
  # Authentication Concern에서 제공하는 allow_unauthenticated_access를 사용합니다.
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 회원가입 성공 시 바로 세션을 생성하여 로그인 상태로 만듭니다.
      session_record = @user.sessions.create!(
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )
      cookies.signed.permanent[:session_id] = { value: session_record.id, httponly: true, same_site: :lax }

      redirect_to root_path, notice: "会員登録が完了しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
