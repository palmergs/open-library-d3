class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :ident,  limit: 15
      t.string :title, null: false
      t.string :subtitle
      t.text :statement
      t.string :lcc, limit: 15, index: true
      t.integer :pages
      t.integer :publish_date
      t.string :format
      t.string :series
      t.text :excerpt
      t.text :description, null: false, default: ''
      t.integer :edition_authors_count, null: false, default: 0, index: true
      t.integer :work_editions_count, null: false, default: 0, index: true

      t.timestamps null: false
    end

    add_index :editions, :ident, unique: true
  end
end
