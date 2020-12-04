# frozen_string_literal: true

RailsAdmin.config do |config|
  require 'i18n'
  I18n.default_locale = :de

  config.main_app_name = ['MyZivi', 'Sys Manage']

  config.authenticate_with do
    warden.authenticate! scope: :sys_admin
  end
  config.current_user_method(&:current_sys_admin)

  config.authorize_with :cancancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
