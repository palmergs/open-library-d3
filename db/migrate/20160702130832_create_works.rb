class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :ident,    limit: 15, index: true
      t.string :title,    null: false
      t.string :subtitle
      t.integer :editions_count, null: false, default: 0
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end
  end
end
