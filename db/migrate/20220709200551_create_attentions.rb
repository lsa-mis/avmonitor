class CreateAttentions < ActiveRecord::Migration[7.0]
  def change
    create_table :attentions do |t|
      t.string :message

      t.timestamps
    end
  end
end
