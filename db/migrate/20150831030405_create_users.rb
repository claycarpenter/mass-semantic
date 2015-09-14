class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :display_name
      t.string :email
      t.string :gh_user_id
      t.string :se_user_id

      t.timestamps null: false
    end
  end
end
