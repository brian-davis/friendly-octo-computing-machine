# == Route Map
#
#                                   Prefix Verb   URI Pattern                                                                                       Controller#Action
#                         reading_sessions GET    /reading_sessions(.:format)                                                                       reading_sessions#index
#                                          POST   /reading_sessions(.:format)                                                                       reading_sessions#create
#                      new_reading_session GET    /reading_sessions/new(.:format)                                                                   reading_sessions#new
#                     edit_reading_session GET    /reading_sessions/:id/edit(.:format)                                                              reading_sessions#edit
#                          reading_session GET    /reading_sessions/:id(.:format)                                                                   reading_sessions#show
#                                          PATCH  /reading_sessions/:id(.:format)                                                                   reading_sessions#update
#                                          PUT    /reading_sessions/:id(.:format)                                                                   reading_sessions#update
#                                          DELETE /reading_sessions/:id(.:format)                                                                   reading_sessions#destroy
#                               home_index GET    /home/index(.:format)                                                                             home#index
#                     build_work_producers GET    /producers/build_work(.:format)                                                                   producers#build_work
#                    select_work_producers GET    /producers/select_work(.:format)                                                                  producers#select_work
#                                producers GET    /producers(.:format)                                                                              producers#index
#                                          POST   /producers(.:format)                                                                              producers#create
#                             new_producer GET    /producers/new(.:format)                                                                          producers#new
#                            edit_producer GET    /producers/:id/edit(.:format)                                                                     producers#edit
#                                 producer GET    /producers/:id(.:format)                                                                          producers#show
#                                          PATCH  /producers/:id(.:format)                                                                          producers#update
#                                          PUT    /producers/:id(.:format)                                                                          producers#update
#                                          DELETE /producers/:id(.:format)                                                                          producers#destroy
#                               publishers GET    /publishers(.:format)                                                                             publishers#index
#                                          POST   /publishers(.:format)                                                                             publishers#create
#                            new_publisher GET    /publishers/new(.:format)                                                                         publishers#new
#                           edit_publisher GET    /publishers/:id/edit(.:format)                                                                    publishers#edit
#                                publisher GET    /publishers/:id(.:format)                                                                         publishers#show
#                                          PATCH  /publishers/:id(.:format)                                                                         publishers#update
#                                          PUT    /publishers/:id(.:format)                                                                         publishers#update
#                                          DELETE /publishers/:id(.:format)                                                                         publishers#destroy
#                     build_producer_works GET    /works/build_producer(.:format)                                                                   works#build_producer
#                    select_producer_works GET    /works/select_producer(.:format)                                                                  works#select_producer
#                    build_publisher_works GET    /works/build_publisher(.:format)                                                                  works#build_publisher
#                   select_publisher_works GET    /works/select_publisher(.:format)                                                                 works#select_publisher
#                          build_tag_works GET    /works/build_tag(.:format)                                                                        works#build_tag
#                         select_tag_works GET    /works/select_tag(.:format)                                                                       works#select_tag
#                       build_parent_works GET    /works/build_parent(.:format)                                                                     works#build_parent
#                      select_parent_works GET    /works/select_parent(.:format)                                                                    works#select_parent
#                              work_quotes GET    /works/:work_id/quotes(.:format)                                                                  quotes#index
#                                          POST   /works/:work_id/quotes(.:format)                                                                  quotes#create
#                           new_work_quote GET    /works/:work_id/quotes/new(.:format)                                                              quotes#new
#                          edit_work_quote GET    /works/:work_id/quotes/:id/edit(.:format)                                                         quotes#edit
#                               work_quote GET    /works/:work_id/quotes/:id(.:format)                                                              quotes#show
#                                          PATCH  /works/:work_id/quotes/:id(.:format)                                                              quotes#update
#                                          PUT    /works/:work_id/quotes/:id(.:format)                                                              quotes#update
#                                          DELETE /works/:work_id/quotes/:id(.:format)                                                              quotes#destroy
#                               work_notes GET    /works/:work_id/notes(.:format)                                                                   notes#index
#                                          POST   /works/:work_id/notes(.:format)                                                                   notes#create
#                            new_work_note GET    /works/:work_id/notes/new(.:format)                                                               notes#new
#                           edit_work_note GET    /works/:work_id/notes/:id/edit(.:format)                                                          notes#edit
#                                work_note GET    /works/:work_id/notes/:id(.:format)                                                               notes#show
#                                          PATCH  /works/:work_id/notes/:id(.:format)                                                               notes#update
#                                          PUT    /works/:work_id/notes/:id(.:format)                                                               notes#update
#                                          DELETE /works/:work_id/notes/:id(.:format)                                                               notes#destroy
#                    work_reading_sessions GET    /works/:work_id/reading_sessions(.:format)                                                        reading_sessions#index
#                                          POST   /works/:work_id/reading_sessions(.:format)                                                        reading_sessions#create
#                 new_work_reading_session GET    /works/:work_id/reading_sessions/new(.:format)                                                    reading_sessions#new
#                edit_work_reading_session GET    /works/:work_id/reading_sessions/:id/edit(.:format)                                               reading_sessions#edit
#                     work_reading_session GET    /works/:work_id/reading_sessions/:id(.:format)                                                    reading_sessions#show
#                                          PATCH  /works/:work_id/reading_sessions/:id(.:format)                                                    reading_sessions#update
#                                          PUT    /works/:work_id/reading_sessions/:id(.:format)                                                    reading_sessions#update
#                                          DELETE /works/:work_id/reading_sessions/:id(.:format)                                                    reading_sessions#destroy
#                                    works GET    /works(.:format)                                                                                  works#index
#                                          POST   /works(.:format)                                                                                  works#create
#                                 new_work GET    /works/new(.:format)                                                                              works#new
#                                edit_work GET    /works/:id/edit(.:format)                                                                         works#edit
#                                     work GET    /works/:id(.:format)                                                                              works#show
#                                          PATCH  /works/:id(.:format)                                                                              works#update
#                                          PUT    /works/:id(.:format)                                                                              works#update
#                                          DELETE /works/:id(.:format)                                                                              works#destroy
#                                   quotes GET    /quotes(.:format)                                                                                 quotes#general_index
#                       rails_health_check GET    /up(.:format)                                                                                     rails/health#show
#                                     root GET    /                                                                                                 home#index
#         turbo_recede_historical_location GET    /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#         turbo_resume_historical_location GET    /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#        turbo_refresh_historical_location GET    /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#            rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#               rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#            rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#      rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#            rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#             rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#           rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                          POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#        new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#            rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
# new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#    rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#    rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
# rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                       rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                 rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                          GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#          rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                          GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create

Rails.application.routes.draw do
  devise_for :users
  resources :reading_sessions

  get 'home/index'

  concern :notable do
    resources :notes
  end

  # resources :notes

  resources :producers, concerns: :notable do
    collection do
      get :build_work, format: :turbo_stream
      get :select_work, format: :turbo_stream
    end
  end

  resources :publishers

  resources :works, concerns: :notable do
    collection do
      # combined forms
      get :build_producer, format: :turbo_stream
      get :select_producer, format: :turbo_stream
      get :build_publisher, format: :turbo_stream
      get :select_publisher, format: :turbo_stream
      get :build_tag, format: :turbo_stream
      get :select_tag, format: :turbo_stream
      get :build_parent, format: :turbo_stream
      get :select_parent, format: :turbo_stream
      get :clone_work, format: :turbo_stream
    end

    resources :reading_sessions
    resources :quotes
  end

  get "quotes", to: "quotes#general_index", as: "quotes"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end