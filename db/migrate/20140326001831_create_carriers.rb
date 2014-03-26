class CreateCarriers < ActiveRecord::Migration
  def up
    create_table :carriers do |t|
    	t.string :carrier_name

      t.timestamps
    end
  end

  def down
  	drop_table :carriers
  end
end
