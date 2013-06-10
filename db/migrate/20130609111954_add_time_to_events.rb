class AddTimeToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :time, :time, default: Time.zone.parse("00:00:00")
  end
end
