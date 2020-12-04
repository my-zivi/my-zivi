# frozen_string_literal: true

RailsAdmin.config do |config|
  require 'i18n'
  I18n.default_locale = :de

  config.main_app_name = %w[MyZivi SysAdmin]

  config.authenticate_with do
    warden.authenticate! scope: :sys_admin
  end
  config.current_user_method(&:current_sys_admin)

  config.authorize_with :cancancan

  config.navigation_static_links = {
    'Sidekiq' => '/sidekiq'
  }

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  config.show_gravatar = true

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

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'CivilServant' do
    object_label_method { :full_name }
  end

  config.model 'OrganizationMember' do
    object_label_method { :full_name }
  end

  config.model 'User' do
    object_label_method { :email }
  end
end
