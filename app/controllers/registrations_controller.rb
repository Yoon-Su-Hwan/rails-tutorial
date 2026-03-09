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
      # 회원가입 성공 시 활성화 이메일을 발송합니다.
      @user.send_activation_email
      redirect_to root_path, notice: "登録したメールアドレスを確認して、アカウントを有効化してください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :name, :birthdate, :phone_number, :address)
  end
end
