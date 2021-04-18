# frozen_string_literal: true

module JavaScriptErrorReporter
  YELLOW = "\e[33m"
  RESET = "\e[0m"

  RSpec.configure do |config|
    config.after(:each, type: :system, js: true) do
      errors = page.driver.browser.manage.logs.get(:browser)

      if errors.present?
        aggregate_failures 'javascript errors' do
          errors.each do |error|
            expect(error.level).not_to eq('SEVERE'), error.message

            next unless error.level == 'WARNING'

            warn "#{YELLOW}\nJAVASCRIPT WARNING\n#{error.message}#{RESET}"
          end
        end
      end
    end
  end
end
