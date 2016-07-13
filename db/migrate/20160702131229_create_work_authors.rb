class CreateWorkAuthors < ActiveRecord::Migration
  def change
    create_table :work_authors do |t|
      t.integer :work_id, null: false, index: true
      t.integer :author_id, null: false, index: true
      t.integer :rel_order, null: false, default: 0
    end

    add_index :work_authors, [ :work_id, :author_id ], unique: true
  end
end
