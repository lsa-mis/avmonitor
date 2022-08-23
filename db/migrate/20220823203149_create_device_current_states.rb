class CreateDeviceCurrentStates < ActiveRecord::Migration[7.0]
  def change
    create_table :device_current_states do |t|
      t.string :key, null: false
      t.string :value
      t.string :notes
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
