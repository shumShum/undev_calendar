UndevCalendar::Application.routes.draw do
  
  root :to => 'events#index'
  get '/index' => 'events#index'

  resources :events 
  get '/events/:time_option/:year/:month' => 'events#index', constraints: { time_option: /(week|month)/, year: /\d{4}/, month: /\d{2}/} ,
    as: 'events_index_month'
  get '/events/:time_option/:year/:month/:day' => 'events#index', constraints: { time_option: /(day)/, year: /\d{4}/, month: /\d{2}/, day: /\d{2}/} ,
    as: 'events_index_day'

end
