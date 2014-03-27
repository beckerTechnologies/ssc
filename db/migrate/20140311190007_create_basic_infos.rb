class CreateBasicInfos < ActiveRecord::Migration
  def up
    create_table :basic_infos do |t|
      t.integer :profile_id
      t.text :first_name
      t.text :middle_name
      t.text :last_name 
      t.date :dob
      t.text :ssn
      t.timestamps
    end
  end

  def down
    drop_table :basic_infos
  end
end
