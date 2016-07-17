class AddIndexToEditionPublishDate < ActiveRecord::Migration
  def change
    add_index :editions, :publish_date
    add_index :subject_tags, :name
    add_index :external_links, :name
    add_index :tokens, :category
  end
end
