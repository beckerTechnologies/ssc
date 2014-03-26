class AddCarrierIdToProfiles < ActiveRecord::Migration
  def up
  	add_column :profiles, :carrier_id, :integer
  end

  def down
  	remove_column :profiles, :carrier_id, :integer
  end
end
