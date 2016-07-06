class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :ident,    limit: 15, index: true
      t.string :title,    null: false
      t.string :subtitle
      t.string :lcc,      limit: 15, index: true
      t.integer :editions_count, null: false, default: 0
      t.integer :publish_date, index: true
      t.text :sentence
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end
  end
end
