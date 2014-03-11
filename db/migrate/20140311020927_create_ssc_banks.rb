class CreateSscBanks < ActiveRecord::Migration
  def up
    create_table :ssc_banks do |t|
    	t.text :ssc
      t.integer :lifetime
      t.timestamps
    end
  end

  def down
  	drop_table :ssc_banks
  end
end
