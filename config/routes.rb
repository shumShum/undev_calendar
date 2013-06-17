UndevCalendar::Application.routes.draw do
  
  root :to => 'events#index'
  get '/index' => 'events#index'

  resources :events do
    # post :new_repeat_day
    # post :del_repeat_day
  end
  get '/events/:year/:month' => 'events#index', constraints: { year: /\d{4}/, month: /\d{2}/},
    as: 'events_index_month'

end
