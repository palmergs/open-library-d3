class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :ident, limit: 15
      t.string :name, null: false
      t.integer :birth_date, index: true
      t.integer :death_date, index: true
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end

    add_index :authors, :ident, unique: true 
  end
end
