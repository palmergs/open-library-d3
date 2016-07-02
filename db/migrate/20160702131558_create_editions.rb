class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.integer :work_id, null: false, index: true
      t.integer :edition_publishers_count, null: false, default: 0
      t.string :ident,  limit: 15,  index: true
      t.string :title, null: false
      t.string :subtitle
      t.integer :pages
      t.integer :copyright_date
      t.integer :publish_date
      t.integer :publish_country
      t.string :format
      t.string :series
      t.text :first_sentence
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end
  end
end
