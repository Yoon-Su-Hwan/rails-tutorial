Rails.application.routes.draw do
  get "posts/index"
  get "posts/new", to: "posts#new"
  # :id의 경우 어떠한 문자열이라도 올수있는것으로 판단을 하기때문에
  # posts/1, posts/2, posts/3 모두 show 액션으로 보낸며
  # 의도하지않은 숫자가 아닌 문자열이 올수도 있기때문에
  # posts/hello, posts/world, posts/rails 모두 show 액션으로 보낸다
  get "posts/:id", to: "posts#show"
  post "posts", to: "posts#create"

  # Urlは　localhost:3000/posts/indexで
  # アクセスは　postコントローラーのindexアクションにアクセスする
  # get "posts/index", to: "post#index"
  # getは　パスを設定する
  # toは　具体的にどんなviewにおくるのかを決める
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
