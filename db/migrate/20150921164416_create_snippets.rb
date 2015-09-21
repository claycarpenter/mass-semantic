class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :title
      t.string :code
      t.string :expl_md
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
