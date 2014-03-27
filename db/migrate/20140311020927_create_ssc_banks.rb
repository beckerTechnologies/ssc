class CreateSscBanks < ActiveRecord::Migration
  def up
    create_table :ssc_banks do |t|
      t.integer :profile_id #FK
      t.integer :auth_option_id
      t.text :ssc
      t.text :ct_mask # n letters showing the box positions for challenge text. $$
      t.text :auth_value # the value for the selected authOption. $$
      t.datetime :expiry
      t.integer :lifetime # figuring out where its optimal position is. defereing decision till offline app is developed. 
      t.timestamps
    end
  end

  def down
    drop_table :ssc_banks
  end
end
