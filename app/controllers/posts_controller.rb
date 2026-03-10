class PostsController < ApplicationController
  # Authentication Concern에서 제공하는 인증 기능을 사용합니다.
  # index와 show는 로그인하지 않아도 볼 수 있게 허용합니다.
  allow_unauthenticated_access only: %i[ index show ]

  # before_action is a method that is called before the specified actions are executed
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :ensure_owner, only: %i[ edit update destroy ]

  def index
    # index action is used to show all posts
    @posts = Post.all
  end

  def show
    # show action is used to show a single post
    @post = Post.find(params[:id])
  end

  def new
    # new action is used to show a form to create a new post
    @post = Post.new
  end

  def create
    # create action is used to create a new post
    # 현재 로그인한 사용자(Current.user)의 게시글로 생성합니다.
    @post = Current.user.posts.new(post_params)
    if @post.save
      # rails가 post를 저장하는데 성공하면 posts_path(목록)로 이동한다
      redirect_to posts_path, notice: "記事が正常に作成されました。"
    else
      # 만약 post가 저장되지않는다면 new 액션으로 돌아가서 에러메세지를 보여준다
      # unprocessable_entity는 422 에러코드로,
      # 클라이언트가 보낸 요청이 서버에서 처리할 수 없는 경우에 사용 된다
      render :new, status: :unprocessable_entity
    end
  end
...
  def edit
    # edit action is used to show a form to edit a post
    # @post = Post.find(params[:id])
  end

  def update
    # update action is used to update a post
    if @post.update(post_params)
      redirect_to @post, notice: "更新が成功しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # destroy action is used to delete a post
    if @post.destroy
      redirect_to posts_path, notice: "削除が成功しました", status: :see_other
    else
      redirect_to @post, alert: "削除に失敗しました"
    end
  end

  def post_params
    # post_params is used to permit the parameters
    # that are allowed to be passed to the create and update actions
    params.require(:post).permit(:title, :body)
  end

  def set_post
    # set_post is used to set the post variable
    @post = Post.find(params[:id])
  end

  def ensure_owner
    # 게시글 작성자와 현재 로그인한 사용자가 다르면 목록으로 리다이렉트합니다.
    unless @post.user == Current.user
      redirect_to posts_path, alert: "自分以外の投稿は編集・削除できません。"
    end
  end
end
