class CreateEditionAuthors < ActiveRecord::Migration
  def change
    create_table :edition_authors do |t|
      t.integer :edition_id, null: false, index: true
      t.integer :author_id, null: false, index: true
      t.integer :rel_order, null: false, default: 0
    end

    add_index :edition_authors, [ :edition_id, :author_id ], unique: true
  end
end
