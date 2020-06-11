# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::Task['assets:clean'].enhance do
  FileUtils.remove_dir('node_modules', true)
  FileUtils.remove_dir('vendor/javascript', true)
  FileUtils.remove_dir('tmp/cache/webpacker', true)
end
