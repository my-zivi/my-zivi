# frozen_string_literal: true

RailsAdmin.config do |config|
  require 'i18n'
  I18n.default_locale = :'de-CH'

  config.main_app_name = %w[MyZivi SysAdmin]

  config.authenticate_with do
    warden.authenticate! scope: :sys_admin
  end
  config.current_user_method(&:current_sys_admin)

  config.authorize_with :cancancan

  config.navigation_static_links = {
    'Sidekiq' => '/sidekiq',
    'Blog' => '/sys_admins/blog_entries'
  }

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  config.show_gravatar = true

  config.actions do
    dashboard # mandatory
    index # mandatory
    new do
      except ['MailingList']
    end
    export
    bulk_delete
    show
    edit
    delete

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Organization' do
    field :name
    field :identification_number

    field :address do
      nested_form false
    end

    field :creditor_detail do
      nested_form false
    end
    include_all_fields
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

  config.model 'Address' do
    object_label_method { :primary_line }
  end

  config.model 'Service' do
    edit do
      exclude_fields :civil_servant
    end
  end

  config.model 'Workshop' do
    configure :service_specifications_workshops do
      visible(false)
    end

    configure :civil_servants_workshops do
      visible(false)
    end

    configure :job_posting_workshops do
      visible(false)
    end

    edit do
      exclude_fields(:service_specifications, :civil_servants, :job_postings)
    end
  end

  config.model 'JobPosting' do
    edit do
      fields_of_type(:date) do
        strftime_format '%Y-%m-%d'
      end
      include_all_fields
    end
  end

  config.model 'AvailableServicePeriod' do
    edit do
      fields_of_type(:date) do
        strftime_format '%Y-%m-%d'
      end
    end
  end
end
