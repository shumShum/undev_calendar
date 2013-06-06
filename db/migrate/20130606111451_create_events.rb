class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
    	t.datetime :date
    	t.string :description

      t.timestamps
    end
  end
end
