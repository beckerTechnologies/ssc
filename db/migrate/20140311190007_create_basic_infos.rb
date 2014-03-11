class CreateBasicInfos < ActiveRecord::Migration
  def up
    create_table :basic_infos do |t|
    	t.text :first_name
    	t.text :middle_name
    	t.text :last_name 
    	t.date :dob
      t.timestamps
    end
  end

  def down
  	drop_table :basic_infos
  end
end
