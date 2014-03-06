Dummy::Application.routes.draw do
  root "dummy#index"
  get "/assets/application", to: "dummy#assets"
end
