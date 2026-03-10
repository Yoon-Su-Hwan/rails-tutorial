class UsersController < ApplicationController
  # Current.user를 사용하므로 별도의 set_user는 필요하지 않지만, 가독성을 위해 @user에 할당합니다.
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: "プロフィールが更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # 세션 종료 (쿠키 삭제 및 세션 레코드 삭제)
    terminate_session
    # 사용자 삭제 (dependent: :destroy 설정으로 인해 관련 게시글도 자동 삭제됨)
    @user.destroy
    redirect_to root_path, notice: "退会手続きが完了しました。ご利用ありがとうございました。", status: :see_other
  end

  private

  def set_user
    @user = Current.user
  end

  def user_params
    # 이메일은 허용 목록에서 제외하여 수정을 방지합니다.
    params.require(:user).permit(:name, :birthdate, :phone_number, :address)
  end
end
