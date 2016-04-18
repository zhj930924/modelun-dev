class CreateUsers < ActiveRecord::Migration
  def change
   create_table :users do |t|
      t.string :name
      t.string :committee
      t.string :position
      t.text   :maps
      t.string :email
      t.string :remember_token
      t.boolean :admin, default: false
      t.string :type 
      t.string :activation_digest 
      t.boolean :activated 
      t.datetime :activated_at 
      
      t.timestamps null: false
    end
  end
end
