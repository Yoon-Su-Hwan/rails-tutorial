class PagesController < ApplicationController
  def home
    # This is called an action
    # @hello_world is an [instance variable]
    #  that can be used in the view
    @hello_world = "Hello Ruby On Rails!"
  end
  # about view action
  def about
    # This is called an action
  end
end
