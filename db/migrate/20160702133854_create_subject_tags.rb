class CreateSubjectTags < ActiveRecord::Migration
  def change
    create_table :subject_tags do |t|
      t.integer :taggable_id, null: false
      t.string :taggable_type, null: false, limit: 24
      t.string :name, null: false, limit: 24
      t.string :value, null: false

      t.timestamps null: false
    end

    add_index :subject_tags, [ :taggable_id, :taggable_type ]
  end
end
