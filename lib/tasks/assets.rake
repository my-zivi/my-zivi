# frozen_string_literal: true

namespace :assets do
  desc 'Cleans assets'
  task clean: :environment do
    FileUtils.remove_dir('node_modules', true)
    FileUtils.remove_dir('vendor/javascript', true)
    FileUtils.remove_dir('tmp/cache/webpacker', true)
  end
end
