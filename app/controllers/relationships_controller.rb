class RelationshipsController < ApplicationController
  # RelationshipsController는 기본적으로 로그인이 필요합니다 (ApplicationController 상속).

  def create
    user = User.find(params[:followed_id])
    Current.user.follow(user)
    redirect_to request.referrer || root_path, notice: "#{user.name}様をフォローしました。"
  end

  def destroy
    # Relationship ID를 통해 상대방(followed) 정보를 가져옵니다.
    relationship = Relationship.find(params[:id])
    user = relationship.followed
    
    # 현재 로그인한 사용자가 팔로우를 취소합니다.
    Current.user.unfollow(user)
    
    redirect_to request.referrer || root_path, notice: "#{user.name}様のフォローを解除しました。", status: :see_other
  end
end
