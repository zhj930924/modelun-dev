Rails.application.routes.draw do
  # devise_for :users do
  #   get '/users/sign_out' => 'devise/sessions#destroy'
  # end

  # , :controllers => { registrations: 'registrations' }

  #devise_scope :user do

  #  authenticated :user do
  #    get "dashboard" => "users#show"
  #  end

  #  unauthenticated :user do
  #    root to: "static_pages#home"
  #  end

  # end


  devise_for :users
  root to: "static_pages#home"
  # mailbox folder routes
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash
  # get "sort" => "users#index", as: :users_path
  # conversations
  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  resource :account, only: [:show]
  # For the chat
  post 'tokens' => "tokens#create"

  # get 'sessions/new'
  # get 'users/new'
  # get 'signup' => 'users#new'
  # root to: "static_pages#home"
  # get 'login' => 'sessions#new'
  # post 'login' => 'sessions#create'
  # get 'chat' => 'users#index'

  get 'contact' => 'static_pages#contact'
  get 'about' => 'static_pages#about'
  get 'user/all' => 'users#index'
  get "notes" => 'static_pages#notes'
  get "crisis_updates" => 'crisis_updates#crisis_updates'
  get "public_resolutions" => 'resolutions#public_resolutions'
  get "private_resolutions" => 'resolutions#private_resolutions'
  get "documents" => 'static_pages#documents'
  get 'static_pages/download' => 'static_pages#download'
  get "resolution_management" => 'resolutions#resolution_management'
  get "resolution_requests" => 'resolution_requests#create'
  get "resolution_signings_create" => 'resolution_signings#create'
  delete 'resolution_signings_destroy' => 'resolution_signings#destroy'
  delete 'resolution_signings' => 'resolution_signings#destroy'
  delete 'directives_tags' => 'directives_tags#destroy'
  delete 'resolution_requests' => 'resolution_requests#destroy'
  delete 'resolution_sponsorships' => 'resolution_sponsorships#destroy'



  resources :users
  resources :crises, :controller => "users", :type => "Crisis"
  resources :delegates, :controller => "users", :type => "Delegate"

  resources :comments, only: [:index, :create]
  get '/comments/new/(:parent_id)', to: 'comments#new', as: :new_comment

  resources :directives
  resources :personal_directives,  :controller => "personal_directives"
  resources :resolutions, :controller => "resolutions"
  resources :crisis_updates, :controller => "crisis_updates"
  resources :notes, :controller => "notes", only: [:create, :destroy]
  resources :tags
  resources :directives_tags
  resources :resolution_sponsorships, only: [:create, :destroy]
  resources :resolution_signings, only: [:create, :destroy]
  resources :resolution_requests, only: [:create, :destroy]

  #root to: "static_pages#home"


# Tutorial: Authentication :: Override default setup = devise_for :users
#  # http://iampedantic.com/post/41170460234/fully-customizing-devise-routes
#  devise_for :users, skip: [:sessions, :passwords, :confirmations, :registrations, :unlocks]
#  devise_scope :user do
#
#    # authentication
#    unauthenticated :user do
#      root to: 'users/sessions#new', as: 'new_user_session'
#    end
#    authenticated :user do
#      root to: 'dashboard#index'
#    end

#    post '/login', to: 'users/sessions#create', as: 'user_session'
#   get '/logout', to: 'users/sessions#destroy', as: 'destroy_user_session'
#
#    # registrations
#    get '/join', to: 'users/registrations#new', as: 'new_user_registration'
#    post '/join', to: 'users/registrations#create', as: 'user_registration'

#    # user accounts
#    scope '/account' do
#      # confirmation
#      get '/verification', to: 'users/confirmations#verification_sent', as: 'user_verification_sent'
#      get '/confirm', to: 'users/confirmations#show', as: 'user_confirmation'
#      get '/confirm/resend', to: 'users/confirmations#new', as: 'new_user_confirmation'
#      post '/confirm', to: 'users/confirmations#create'

#      # passwords
#      get '/reset-password', to: 'users/passwords#new', as: 'new_user_password'
#      get '/reset-password/change', to: 'users/passwords#edit', as: 'edit_user_password'
#      put  '/reset-password', to: 'users/passwords#update', as: 'user_password'
#      post '/reset-password', to: 'users/passwords#create'

#      # unlocks
#      post '/unlock', to: 'users/unlocks#create', as: 'user_unlock'
#      get '/unlock/new', to: 'users/unlocks#new', as: 'new_user_unlock'
#      get '/unlock', to: 'users/unlocks#show'

#      # settings & cancellation
#      # get '/cancel', to: 'users/registrations#cancel', as: 'cancel_user_registration'
#      # get '/settings', to: 'users/registrations#edit', as: 'edit_user_registration'
#      # put '/settings', to: 'users/registrations#update'
#      # account deletion
#      # delete '', to: 'users/registrations#destroy'
#    end
#  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
