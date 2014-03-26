class AddCarrierValueToCarriersTable < ActiveRecord::Migration
  def up
  	add_column :carriers, :carrier_value, :string
  end

  def down
  	remove_column :carriers, :carrier_value, :string
  end
end
