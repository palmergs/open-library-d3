class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token_type, null: false, limit: 20 
      t.integer :category, null: false
      t.integer :year, null: false, index: true
      t.string :token, null: false, limit: 60, index: true
      t.integer :count, null: false, default: 0
    end

    add_index :tokens, [ :token_type, :category, :year ]
  end
end
