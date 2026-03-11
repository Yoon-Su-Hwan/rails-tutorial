class RelationshipsController < ApplicationController
  # RelationshipsController는 기본적으로 로그인이 필요합니다 (ApplicationController 상속).

  def create
    user = User.find(params[:followed_id])
    Current.user.follow(user)
    redirect_to request.referrer || root_path, notice: "#{user.name}様をフォローしました。"
  end

  def destroy
    # Relationship 모델에서 삭제 대상을 찾습니다.
    # followed_id를 통해 대상을 찾아 언팔로우합니다.
    user = Relationship.find(params[:id]).followed
    Current.user.unfollow(user)
    redirect_to request.referrer || root_path, notice: "#{user.name}様のフォローを解除しました。"
  end
end
