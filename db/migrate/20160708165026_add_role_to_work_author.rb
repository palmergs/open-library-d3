class AddRoleToWorkAuthor < ActiveRecord::Migration
  def change
    add_column :work_authors, :role, :string, limit: 24, index: true, null: false, default: 'author'
  end
end
