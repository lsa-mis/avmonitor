class AddNickNameToRoom < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :building_nickname, :string
  end
end
