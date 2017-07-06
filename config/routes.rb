# == Route Map
#
#                                  Prefix Verb     URI Pattern                                              Controller#Action
#                                         GET      /oauth/authorize/:code(.:format)                         doorkeeper/authorizations#show
#                     oauth_authorization GET      /oauth/authorize(.:format)                               doorkeeper/authorizations#new
#                                         POST     /oauth/authorize(.:format)                               doorkeeper/authorizations#create
#                                         DELETE   /oauth/authorize(.:format)                               doorkeeper/authorizations#destroy
#                             oauth_token POST     /oauth/token(.:format)                                   doorkeeper/tokens#create
#                            oauth_revoke POST     /oauth/revoke(.:format)                                  doorkeeper/tokens#revoke
#                      oauth_applications GET      /oauth/applications(.:format)                            doorkeeper/applications#index
#                                         POST     /oauth/applications(.:format)                            doorkeeper/applications#create
#                   new_oauth_application GET      /oauth/applications/new(.:format)                        doorkeeper/applications#new
#                  edit_oauth_application GET      /oauth/applications/:id/edit(.:format)                   doorkeeper/applications#edit
#                       oauth_application GET      /oauth/applications/:id(.:format)                        doorkeeper/applications#show
#                                         PATCH    /oauth/applications/:id(.:format)                        doorkeeper/applications#update
#                                         PUT      /oauth/applications/:id(.:format)                        doorkeeper/applications#update
#                                         DELETE   /oauth/applications/:id(.:format)                        doorkeeper/applications#destroy
#           oauth_authorized_applications GET      /oauth/authorized_applications(.:format)                 doorkeeper/authorized_applications#index
#            oauth_authorized_application DELETE   /oauth/authorized_applications/:id(.:format)             doorkeeper/authorized_applications#destroy
#                        oauth_token_info GET      /oauth/token/info(.:format)                              doorkeeper/token_info#show
#                                api_base          /                                                        API::Base
#                     grape_swagger_rails          /swagger                                                 GrapeSwaggerRails::Engine
#                             rails_admin          /admin                                                   RailsAdmin::Engine
#                                    root GET      /                                                        welcome#index
#                                                  /404(.:format)                                           exceptions#not_found
#                                                  /500(.:format)                                           exceptions#internal_server_error
#                              onboarding GET      /onboarding(.:format)                                    onboarding#index
#                               edit_mode GET      /edit_mode(.:format)                                     application#edit_mode
#                       conditions_of_use GET      /conditions_of_use(.:format)                             redirect(301, /documents/conditions_of_use.pdf)
#                                         GET      /.well-known/acme-challenge/:id(.:format)                application#letsencrypt
#                       organigraph_index GET      /organigraph(.:format)                                   organigraph#index
#                             organigraph GET      /organigraph/:id(.:format)                               organigraph#show
#                           relationships POST     /relationships(.:format)                                 relationships#create
#                        new_relationship GET      /relationships/new(.:format)                             relationships#new
#                            relationship DELETE   /relationships/:id(.:format)                             relationships#destroy
#                               user_jobs POST     /p/:user_id/jobs(.:format)                               jobs#create
#                                user_job PATCH    /p/:user_id/jobs/:id(.:format)                           jobs#update
#                                         PUT      /p/:user_id/jobs/:id(.:format)                           jobs#update
#                                         DELETE   /p/:user_id/jobs/:id(.:format)                           jobs#destroy
#                             user_skills POST     /p/:user_id/skills(.:format)                             skills#create
#                              user_skill DELETE   /p/:user_id/skills/:id(.:format)                         skills#destroy
#                          user_languages POST     /p/:user_id/languages(.:format)                          languages#create
#                           user_language DELETE   /p/:user_id/languages/:id(.:format)                      languages#destroy
# autocomplete_project_name_user_projects GET      /p/:user_id/projects/autocomplete_project_name(.:format) projects#autocomplete_project_name
#                            user_project PATCH    /p/:user_id/projects/:id(.:format)                       projects#update
#                                         PUT      /p/:user_id/projects/:id(.:format)                       projects#update
#                                         DELETE   /p/:user_id/projects/:id(.:format)                       projects#destroy
#             user_project_participations POST     /p/:user_id/project_participations(.:format)             project_participations#create
#              user_project_participation PATCH    /p/:user_id/project_participations/:id(.:format)         project_participations#update
#                                         PUT      /p/:user_id/project_participations/:id(.:format)         project_participations#update
#                                         DELETE   /p/:user_id/project_participations/:id(.:format)         project_participations#destroy
#                            user_degrees POST     /p/:user_id/degrees(.:format)                            degrees#create
#                             user_degree PATCH    /p/:user_id/degrees/:id(.:format)                        degrees#update
#                                         PUT      /p/:user_id/degrees/:id(.:format)                        degrees#update
#                                         DELETE   /p/:user_id/degrees/:id(.:format)                        degrees#destroy
#                      autocomplete_users GET      /p/autocomplete(.:format)                                profiles#autocomplete
#                         user_graph_json GET      /p/:user_id/graph_json(.:format)                         profiles#graph_json
#                          user_user_json GET      /p/:user_id/user_json(.:format)                          profiles#user_json
#                       import_list_users POST     /p/import_list(.:format)                                 profiles#import_list
#                                   users GET      /p(.:format)                                             profiles#index
#                                    user GET      /p/:id(.:format)                                         profiles#show
#                                         PATCH    /p/:id(.:format)                                         profiles#update
#                                         PUT      /p/:id(.:format)                                         profiles#update
#                                  skills GET      /skills(.:format)                                        skills#index
#               autocomplete_project_name GET      /autocomplete_project_name(.:format)                     projects#autocomplete_project_name
#              autocomplete_language_name GET      /autocomplete_language_name(.:format)                    languages#autocomplete_language_name
#                 autocomplete_skill_name GET      /autocomplete_skill_name(.:format)                       skills#autocomplete_skill_name
#                autocomplete_school_name GET      /autocomplete_school_name(.:format)                      schools#autocomplete_school_name
#                        new_user_session GET      /users/sign_in(.:format)                                 devise/sessions#new
#                            user_session POST     /users/sign_in(.:format)                                 devise/sessions#create
#                    destroy_user_session DELETE   /users/sign_out(.:format)                                devise/sessions#destroy
#        user_linkedin_omniauth_authorize GET|POST /users/auth/linkedin(.:format)                           users/omniauth_callbacks#passthru
#         user_linkedin_omniauth_callback GET|POST /users/auth/linkedin/callback(.:format)                  users/omniauth_callbacks#linkedin
#                           user_password POST     /users/password(.:format)                                users/passwords#create
#                       new_user_password GET      /users/password/new(.:format)                            users/passwords#new
#                      edit_user_password GET      /users/password/edit(.:format)                           users/passwords#edit
#                                         PATCH    /users/password(.:format)                                users/passwords#update
#                                         PUT      /users/password(.:format)                                users/passwords#update
#                cancel_user_registration GET      /users/cancel(.:format)                                  users/registrations#cancel
#                       user_registration POST     /users(.:format)                                         users/registrations#create
#                   new_user_registration GET      /users/sign_up(.:format)                                 users/registrations#new
#                  edit_user_registration GET      /users/edit(.:format)                                    users/registrations#edit
#                                         PATCH    /users(.:format)                                         users/registrations#update
#                                         PUT      /users(.:format)                                         users/registrations#update
#                                         DELETE   /users(.:format)                                         users/registrations#destroy
#                       user_confirmation POST     /users/confirmation(.:format)                            users/confirmations#create
#                   new_user_confirmation GET      /users/confirmation/new(.:format)                        users/confirmations#new
#                                         GET      /users/confirmation(.:format)                            users/confirmations#show
#
# Routes for GrapeSwaggerRails::Engine:
#   root GET  /           grape_swagger_rails/application#index
#
# Routes for RailsAdmin::Engine:
#    dashboard GET         /                                      rails_admin/main#dashboard
#        index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#          new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#       export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
#  bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
# import_users GET         /:model_name/import_users(.:format)    rails_admin/main#import_users
#  bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#         show GET         /:model_name/:id(.:format)             rails_admin/main#show
#         edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#       delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
#  show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
#

# Routes for RailsAdmin::Engine:
#    dashboard GET         /                                      rails_admin/main#dashboard
#        index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#          new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#       export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
#  bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
# import_users GET         /:model_name/import_users(.:format)    rails_admin/main#import_users
#  bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#         show GET         /:model_name/:id(.:format)             rails_admin/main#show
#         edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#       delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
#  show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app
#

Rails.application.routes.draw do

  # API related
  use_doorkeeper
  mount API::Base, at: "/"
  mount GrapeSwaggerRails::Engine => "/swagger"

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  root 'welcome#index'

  # Error pages handling
  match '/404', to: 'exceptions#not_found', via: :all
  match '/500', to: 'exceptions#internal_server_error', via: :all

  get '/onboarding', to: 'onboarding#index', as: 'onboarding'
  get '/edit_mode', to: 'application#edit_mode'
  get '/conditions_of_use', to: redirect(ENV['CONDITIONS_OF_USE_FILE_URL'] || '/')

  resources :organigraph, only: [:index, :show]

  resources :relationships, only: [:create, :destroy, :new]

  resources :users, controller: "profiles", only: [:show, :update, :index, :destroy, :graph], path: "p" do
    resources :jobs, only: [:create, :destroy, :update]
    resources :skills, only: [:create, :destroy]
    resources :languages, only: [:create, :destroy]
    resources :projects, only: [:update, :destroy] do
      get :autocomplete_project_name, on: :collection
    end
    resources :project_participations, only: [:create, :update, :destroy]
    resources :degrees, only: [:create, :destroy, :update]
    get :autocomplete, on: :collection
    get :graph_json
    get :user_json
    post :import_list, on: :collection
  end

  post :import_jobs, to: "jobs#import_list"
  get :skills, to: "skills#index"
  get :autocomplete_project_name, to: "projects#autocomplete_project_name"
  get :autocomplete_language_name, to: "languages#autocomplete_language_name"
  get :autocomplete_skill_name, to: "skills#autocomplete_skill_name"
  get :autocomplete_school_name, to: "schools#autocomplete_school_name"

  devise_for :users, controllers: {
      registrations:      'users/registrations',
      confirmations:      'users/confirmations',
      omniauth_callbacks: 'users/omniauth_callbacks',
      passwords:          'users/passwords'
  }

end
