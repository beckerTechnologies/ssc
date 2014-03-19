class CreateAuthOptions < ActiveRecord::Migration
  def up
    create_table :auth_options do |t|
      t.text :name
      t.integer :lenght #TODO fix spellings. 

      t.timestamps
    end
  end

  def down
    drop_table :auth_options
  end
end
