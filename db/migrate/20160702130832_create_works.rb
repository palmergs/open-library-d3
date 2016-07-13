class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :ident, limit: 15
      t.string :title, null: false
      t.string :subtitle
      t.string :lcc, limit: 15, index: true
      t.integer :publish_date, index: true
      t.text :excerpt
      t.text :description, null: false, default: ''
      t.integer :work_authors_count, null: false, default: 0, index: true

      t.timestamps null: false
    end

    add_index :works, :ident, unique: true
  end
end
