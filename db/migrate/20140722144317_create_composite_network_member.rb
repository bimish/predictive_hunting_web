class CreateCompositeNetworkMember < ActiveRecord::Migration
  def change
    create_table :composite_network_member do |t|
      t.references :composite_network, index: true, null: false
      t.references :member_network, index: true, null: false

      t.timestamps
    end
    add_index :composite_network_member, [:composite_network_id, :member_network_id], :unique => true, name:'idx_composite_network_member_on_composite_and_member_networks'
  end
end
