Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/help", to: "static_page#help"
    get "/about", to: "static_page#about"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: %i(new show create)
  end
end
