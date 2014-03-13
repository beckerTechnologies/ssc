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
      t.text :country #change it to integer and make country a drop down. $$
      t.text :ssc_value # the value for the selected authOption. $$
      t.text :ct_mask # n letters showing the box positions for challenge text. $$
      t.timestamps
    end
  end

  def down
  	drop_table :profiles
  end
end
