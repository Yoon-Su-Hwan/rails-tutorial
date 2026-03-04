class PostsController < ApplicationController
  def index
  end

  def show
    # show action is used to show a single post
    @post = Post.find(params[:id])
  end

  def new
    # new action is used to show a form to create a new post
  end

  def create
    # create action is used to create a new post
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
end
