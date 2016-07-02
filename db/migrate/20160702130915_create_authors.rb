class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :ident,  limit: 15, index: true
      t.string :name,   null: false
      t.string :personal_name
      t.integer :birth_date
      t.integer :death_date
      t.string :death_place
      t.text :description, null: false, default: ''

      t.timestamps null: false
    end
  end
end
