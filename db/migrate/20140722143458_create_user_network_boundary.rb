class CreateUserNetworkBoundary < ActiveRecord::Migration
  def change
    create_table :user_network_boundary do |t|
      t.references :user_network, index: true, null: false
      t.polygon :boundary, :srid => 4326

      t.timestamps
    end
    add_index :user_network_boundary, :boundary, :spatial => true
  end
end
