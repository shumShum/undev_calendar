UndevCalendar::Application.routes.draw do
  
  root :to => 'events#index'
  get '/index' => 'events#index'

  resources :events do
    post :new_repeat_day
  end

end
