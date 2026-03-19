Rails.application.routes.draw do
  scope '/cs' do
    resources :devices
  end
end
