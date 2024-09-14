class AddTitleToStory < ActiveRecord::Migration[7.1]
  def change
    add_column :stories, :title, :string, null: false
  end
end
