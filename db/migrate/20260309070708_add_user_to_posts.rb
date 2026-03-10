class AddUserToPosts < ActiveRecord::Migration[8.1]
  def change
    # 배포 환경에서 기존 게시글이 있을 경우 user_id가 없어 발생하는 오류를 방지하기 위해 
    # 기존 게시글을 모두 삭제하고 시작합니다.
    execute "DELETE FROM posts"
    add_reference :posts, :user, null: false, foreign_key: true
  end
end
