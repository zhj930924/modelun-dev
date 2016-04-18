class CreateManages < ActiveRecord::Migration
  def change
    create_table :manages do |t|
      t.integer :delegate_id
      t.integer :crisis_id
      
    end
    add_index :manages, [:delegate_id, :crisis_id], unique:true
  end
end
