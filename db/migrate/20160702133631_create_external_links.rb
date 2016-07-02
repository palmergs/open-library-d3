class CreateExternalLinks < ActiveRecord::Migration
  def change
    create_table :external_links do |t|
      t.integer :linkable_id, null: false
      t.string :linkable_type, limit: 63, null: false
      t.string :name, null: false
      t.string :value, null: false

      t.timestamps null: false
    end

    add_index :external_links, [ :linkable_id, :linkable_type ]
  end
end
