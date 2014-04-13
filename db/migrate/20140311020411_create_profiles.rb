class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.text :email
      t.text :password
      t.text :home_phone_number
      t.text :phone_number
      t.integer :carrier_id
      t.timestamps
    end
  end

  def down
  	drop_table :profiles
  end
end
