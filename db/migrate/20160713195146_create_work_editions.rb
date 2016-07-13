class CreateWorkEditions < ActiveRecord::Migration
  def change
    create_table :work_editions do |t|
      t.integer :work_id, null: false, index: true
      t.integer :edition_id, null: false, index: true
      t.integer :rel_order, null: false, default: 0
    end

    add_index :work_editions, [ :work_id, :edition_id ], unique: true
  end
end
