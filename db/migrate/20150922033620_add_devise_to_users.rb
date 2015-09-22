class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    # Add Omniauth properties
    add_column :users, :provider, :string, null: false
    add_column :users, :uid, :string, null: false

    # Remove old custom Oauth properties
    remove_column :users, :gh_user_id
    remove_column :users, :se_user_id
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
