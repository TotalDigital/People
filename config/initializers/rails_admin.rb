require Rails.root.join('lib', 'rails_admin', 'import_users.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ImportUsers)

require Rails.root.join('lib', 'rails_admin', 'import_jobs.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ImportJobs)

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.current_user_method(&:current_user)
  config.authorize_with do
    redirect_to main_app.root_path unless current_user && current_user.admin?
  end

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.actions do
    dashboard # mandatory
    index # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    import_users
    import_jobs

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
