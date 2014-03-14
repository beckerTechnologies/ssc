class AddIndexAll < ActiveRecord::Migration
  def up
    add_index :profiles, :email, unique: true
    add_index :ssc_banks, :ssc, unique: true
    add_index :basic_infos, :ssn, unique: true
  end
  def down
#    remove_index :profiles, :email
#    remove_index :ssc_banks, :ssc
#    remove_index :basic_infos, :ssn
  end
end
