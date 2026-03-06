class PostsController < ApplicationController
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
      # if rails successfully saves the post, redirect to the show action
      # the reason for redirecting to show is to display the post
      # using the post's id in the show action after it is saved
      redirect_to @post
    else
      # if the post is not saved, return to the new action and show an error message
      # unprocessable_entity is HTTP status code 422,
      # used when a request sent by the client cannot be processed by the server
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # edit action is used to show a form to edit a post
  end

  def update
    # update action is used to update a post
  end

  def destroy
    # destroy action is used to delete a post
  end

  def post_params
    # post_params is used to permit the parameters
    # that are allowed to be passed to the create and update actions
    params.require(:post).permit(:title, :body)
  end
end
