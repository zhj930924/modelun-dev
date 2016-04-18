class CreateDirectivesUsers < ActiveRecord::Migration
  def change
    create_table :directives_users do |t|
      t.belongs_to :user
      t.belongs_to :directive
      t.string :type
    end
    add_index :directives_users, [:user_id, :directive_id]
  end
end
