Rails.application.routes.draw do
  get "posts", to: "posts#index"
  get "posts/new", to: "posts#new"
  # :id can be any string, so it is treated as a wildcard parameter
  # posts/1, posts/2, posts/3 are all sent to the show action
  # unintended non-numeric strings can also be passed,
  # so posts/hello, posts/world, posts/rails are all sent to the show action
  # as: "post" allows the use of the post_path helper method when sending to the show action
  get "posts/:id", to: "posts#show", as: "post"
  # the router receives this request and sends it to the create action of posts_controller
  post "posts", to: "posts#create"
  get "posts/:id/edit", to: "posts#edit", as: "edit_post"


  # URL is localhost:3000/posts/index
  # Access the index action of the posts controller
  # get "posts/index", to: "post#index"
  # get sets the path
  # to determines which view to send to
  get "pages/home", to: "pages#home"
  get "pages/about", to: "pages#about"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root page localhost:3000
  root "pages#home"
end
