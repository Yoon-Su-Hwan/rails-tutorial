class SecurityResetsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email_address: params[:email_address])
    if @user
      if @user.security_question_id.present?
        # ID 대신 임의의 문자열(password)과 이메일 파라미터만 사용하여 다음 단계로 이동합니다.
        redirect_to edit_security_reset_path("password", email: @user.email_address)
      else
        redirect_to new_security_reset_path, alert: "このアカウント에는 秘密の質問이 설정되어 있지 않습니다."
      end
    else
      redirect_to new_security_reset_path, alert: "メールアドレスが見つかりません。"
    end
  end

  def edit
  end

  def update
    # 1. 보안 질문 답변 검증
    if @user.correct_security_answer?(params[:user][:security_answer])
      # 2. 비밀번호 업데이트 시도
      if @user.update(password_params)
        # 성공 시 모든 세션 종료 후 로그인 페이지로
        @user.sessions.destroy_all
        redirect_to new_session_path, notice: "パスワードが正常に再設定されました。新しいパスワードでログインしてください。"
      else
        # 비밀번호 유효성 검사 실패 (너무 짧음 등)
        render :edit, status: :unprocessable_entity
      end
    else
      # 답변 틀림
      @user.errors.add(:base, "秘密の質問の答えが正しくありません。")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    # URL의 이메일 파라미터로 유저를 직접 찾습니다.
    @user = User.find_by(email_address: params[:email])
    
    if @user.nil?
      redirect_to new_security_reset_path, alert: "無効なリクエストです。"
    end
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
