class AddTimestamps < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :service_specifications
  end
end
