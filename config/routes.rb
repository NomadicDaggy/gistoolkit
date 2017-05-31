Rails.application.routes.draw do
  # Piesaista vietnes noklusējuma maršrutu kartes kontrolierim
  root 'map#index'

  # Sagatavo kapsētu datu pieprasījumus JSON formātā
  get  '/cemeteries/cemetery_data', :defaults => { :format => 'json' }
  get  '/cemeteries/plots_data',    :defaults => { :format => 'json' }
  get  '/cemeteries/streets_data',  :defaults => { :format => 'json' }
  get  '/cemeteries/points_data',   :defaults => { :format => 'json' }
  get  '/cemeteries/sectors_data',  :defaults => { :format => 'json' }

  # Manuāli piesaista maršrutus kontrolieru metodēm
  get  '/help',            to: 'static_pages#help'
  get  '/info',            to: 'static_pages#info'
  get  '/contact',         to: 'static_pages#contact'
  get  '/signup',          to: 'users#new'
  get    '/login',         to: 'sessions#new'
  post   '/login',         to: 'sessions#create'
  delete '/logout',        to: 'sessions#destroy'

  # Automātiski piesaista maršrutus kontrolieru metodēm
  resources :cemeteries, only: [:index, :show]
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Iespējo cross-origin pieprasījumus (CORS)
  match '*path', via: [:options], to:  lambda {|_| [204, {'Access-Control-Allow-Headers' => "Origin, Content-Type, Accept, Authorization, Token", 'Access-Control-Allow-Origin' => "*", 'Content-Type' => 'text/plain'}, []]}
end
