class AddTportToRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :tport, :integer, null: false
  end
end
