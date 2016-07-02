class CreateEditonPublishers < ActiveRecord::Migration
  def change
    create_table :editon_publishers do |t|
      t.string :name, null: false, limit: 63
      t.integer :edition_id, null: false, index: true

      t.timestamps null: false
    end
  end
end
