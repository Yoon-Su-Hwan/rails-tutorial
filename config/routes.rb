Rails.application.routes.draw do
  resource :session
  
  # Signup routes
  get "signup", to: "registrations#new", as: "signup"
  post "signup", to: "registrations#create"

  # Account Activations routes
  resources :account_activations, only: [:edit]

  # Profile (My Page) routes
  resource :profile, controller: "users", only: [:show, :edit, :update, :destroy] do
    get "password", on: :member, action: :edit_password
    patch "password", on: :member, action: :update_password
    get "following", on: :member
    get "followers", on: :member
  end

  # Security Question Password Reset routes
  resources :security_resets, only: [:new, :create, :edit, :update]

  resources :relationships, only: [:create, :destroy]

  resources :passwords, param: :token
  
  get "posts", to: "posts#index", as: "posts"
  get "posts/new", to: "posts#new", as: "new_post"
  
  # :id의 경우 어떠한 문자열이라도 올수있는것으로 판단을 하기때문에
  # posts/1, posts/2, posts/3 모두 show 액션으로 보낸며
  # 의도하지않은 숫자가 아닌 문자열이 올수도 있기때문에
  # posts/hello, posts/world, posts/rails 모두 show 액션으로 보낸다
  # as: "post"는 show 액션으로 보낼때 post_path라는 헬퍼 메서드를 사용할 수 있도록 해준다
  get "posts/:id", to: "posts#show", as: "post"
  
  # router는 이요청을 받고 posts_controller의 create 액션으로 보낸다
  post "posts", to: "posts#create"
  get "posts/:id/edit", to: "posts#edit", as: "edit_post"
  
  # patch는 update 액션으로 보낸다
  patch "posts/:id", to: "posts#update"
  # delete route
  delete "posts/:id", to: "posts#destroy"

  get "pages/home", to: "pages#home"
  get "pages/about", to: "pages#about"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
