class AlterColumnSnippetExplMdCode < ActiveRecord::Migration
  def change
    change_table :snippets do |t|
      t.change :code, :text
      t.change :expl_md, :text
    end
  end
end
