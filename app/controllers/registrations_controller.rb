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
      # 회원가입 성공 시 바로 세션을 생성하여 로그인 상태로 만듭니다. (브라우저 종료 시 세션 만료)
      start_new_session_for @user

      redirect_to root_path, notice: "会員登録가 완료되었습니다. 환영합니다!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
