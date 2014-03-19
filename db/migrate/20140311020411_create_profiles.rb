class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.text :email
      t.text :password
      t.text :phone_number
      t.text :street_addr
      t.text :apartment_no
      t.text :city
      t.text :zip_code
      t.text :state
      t.text :country #change it to integer and make country a drop down. $$
      t.integer :auth_option_id # FK
      t.text :ssc_value # the value for the selected authOption. $$
      t.integer :ssc_lifetime #when ever ssc is created, its expiry is set to now+life_time
      t.timestamps
    end
  end

  def down
  	drop_table :profiles
  end
end
