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
      # [임시 조치] 메일 서비스 차단으로 인해 가입 즉시 활성화 처리합니다.
      @user.activate
      start_new_session_for @user
      
      redirect_to root_path, notice: "会員登録が完了し、ログインしました！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :name, :birthdate, :phone_number, :address)
  end
end
