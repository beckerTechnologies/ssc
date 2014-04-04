class CreateAddressInfos < ActiveRecord::Migration
  def up
    create_table :address_infos do |t|
      t.integer :profile_id
      t.text :street_addr
      t.text :apartment_no
      t.text :city
      t.text :zip_code
      t.text :state
      t.text :country
      t.timestamps
    end
  end
  
  def down
  	drop_table :address_infos
  end
end
