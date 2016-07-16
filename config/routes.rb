Rails.application.routes.draw do


  namespace :api do
    namespace :v1 do
      resources :works, only: [ :index, :show ]
      resources :authors, only: [ :index, :show ]
      resources :editions, only: [ :index, :show ]
      resources :subject_tags, path: 'subject-tags', only: [ :index, :show ]
      resources :external_links, path: 'external-links', only: [ :index, :show ]
      resources :tokens, only: [ :index, :show ]

      namespace :charts do
        get 'metadata/main', to: 'database_metadata#main_tables'
        get 'metadata/all', to: 'database_metadata#all_tables'
        get 'metadata/tag', to: 'database_metadata#tag_tables'
        get 'metadata/token', to: 'database_metadata#token_tables'

        get 'author/births', to: 'author#birth_timeline'
        get 'work/published', to: 'work#publish_timeline'
        get 'edition/published', to: 'edition#publish_timeline'
      end
    end
  end

  mount_ember_app :frontend, to: '/'


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
