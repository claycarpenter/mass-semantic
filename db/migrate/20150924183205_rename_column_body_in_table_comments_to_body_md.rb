class RenameColumnBodyInTableCommentsToBodyMd < ActiveRecord::Migration
  def change
    rename_column :comments, :body, :body_md
  end
end
