class CreateDirectivesTags < ActiveRecord::Migration
  def change
    create_table :directives_tags do |t|
      t.belongs_to :directive
      t.belongs_to :tag
    end
    add_index :directives_tags, [:tag_id, :directive_id], unique: true
    
  end
end
