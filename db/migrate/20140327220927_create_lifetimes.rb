class CreateLifetimes < ActiveRecord::Migration
  def change
    create_table :lifetimes do |t|
      t.integer :hours
      t.string :name
      t.timestamps
    end
  end
end
