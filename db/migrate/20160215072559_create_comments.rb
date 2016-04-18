class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :directive, index: true, foreign_key: true
      t.text :function
      t.text :content
      t.integer :parent_id

      t.timestamps null: false
    end
    
  end
end
