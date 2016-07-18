class AddIndexToTokenType < ActiveRecord::Migration
  def change
    add_index :tokens, :token_type
  end
end
