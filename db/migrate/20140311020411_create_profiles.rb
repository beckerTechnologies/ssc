class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.text :email
      t.integer :phone_number
      t.text :street_addr
      t.text :apartment_no
      t.text :city
      t.text :zip_code
      t.text :state
      t.text :country
      t.text :ssc_value
      t.integer :ct_mask
    	t.integer :lifetime
      t.timestamps
    end
  end

  def down
  	drop_table :profiles
  end
end
