class CreateUserNetworkSubscription < ActiveRecord::Migration
  def change
    create_table :user_network_subscription do |t|
      t.references :user, index: true, null: false
      t.references :user_network, index: true, null: false
      t.timestamps
    end
    add_index :user_network_subscription, [:user_id, :user_network_id], :unique => true, name:'idx_user_network_subscription_on_user_and_network'
  end
end
