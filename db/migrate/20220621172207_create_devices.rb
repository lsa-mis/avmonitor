class CreateDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :devices do |t|
      t.string :name, null: false
      t.string :description
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
