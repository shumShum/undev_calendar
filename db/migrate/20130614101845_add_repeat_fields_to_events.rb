class AddRepeatFieldsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :is_repeat, :boolean, default: false
  	add_column :events, :repeat_days, :string
  end
end
