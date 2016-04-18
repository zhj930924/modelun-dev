class CreateDirectives < ActiveRecord::Migration
  def change
    create_table :directives do |t|
        t.string :title
        t.text   :content
        t.string :type
        t.boolean :editable, default: true
        t.boolean :claim, default: false
        t.boolean :public, default: false
        t.integer :quality
        t.string :status, default: "Draft"
        t.timestamps null: false

    end
  end
end
