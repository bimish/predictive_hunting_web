class CreateUserGroupMember < ActiveRecord::Migration
  def change
    create_table :user_group_member do |t|
      t.references :user_group, index: true
      t.references :user, index: true
    end
    add_index :user_group_member, [:user_group_id, :user_id], :unique => true, name:'idx_user_group_member_group_and_member'
  end
end
