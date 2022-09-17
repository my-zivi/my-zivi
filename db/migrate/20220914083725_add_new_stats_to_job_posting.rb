class AddNewStatsToJobPosting < ActiveRecord::Migration[6.1]
  def change
    change_table :job_postings, bulk: true do |t|
      t.float :weekly_work_time
      t.boolean :fixed_work_time
      t.boolean :good_reputation
      t.boolean :e_government
      t.boolean :work_on_weekend
      t.boolean :work_night_shift
      t.boolean :accommodation_provided
      t.boolean :food_provided
    end
  end
end
