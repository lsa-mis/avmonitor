class CreateSocketStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :socket_statuses do |t|
      t.string :socket_name
      t.string :status

      t.timestamps
    end
  end
end
