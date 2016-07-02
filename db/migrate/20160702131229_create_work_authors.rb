class CreateWorkAuthors < ActiveRecord::Migration
  def change
    create_table :work_authors do |t|
      t.integer :work_id, null: false, index: true
      t.integer :author_id, null: false, index: true
      t.integer :rel_order, null: false, default: 0
    end
  end
end
