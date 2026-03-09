class PostsController < ApplicationController
  # before_action is a method that is called before the specified actions are executed
  before_action :set_post, only: %i[ show edit update destroy ]
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
    @post = Post.new(post_params)
    if @post.save
      # rails가 post를 저장하는데 성공하면 show 액션으로 이동한다
      # show로 이동되는 이유는 post가 저장된 후에
      #  post의 id를 이용해서 show 액션에서 post를 보여주기 위해서이다
      redirect_to @post
    else
      # 만약 post가 저장되지않는다면 new 액션으로 돌아가서 에러메세지를 보여준다
      # unprocessable_entity는 422 에러코드로,
      # 클라이언트가 보낸 요청이 서버에서 처리할 수 없는 경우에 사용 된다
      render :new, status: :unprocessable_entity
    end
  end

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
end
