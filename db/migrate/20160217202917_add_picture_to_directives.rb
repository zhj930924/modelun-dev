class AddPictureToDirectives < ActiveRecord::Migration
  def change
    add_column :directives, :picture, :string
  end
end
