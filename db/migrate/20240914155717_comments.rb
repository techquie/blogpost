class Comments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.integer :story_id, null: false
      t.boolean :approved_by_admin, default: false
      t.boolean :approved_by_sadmin, default: false
      t.integer :comment_by, null: false

      t.timestamps
    end

    # Added foreign key for 'story_id', referencing 'stories(id)'
    add_foreign_key :comments, :stories, column: :story_id

    # Add foreign key for 'comment_by', referencing 'users(id)'
    add_foreign_key :comments, :users, column: :comment_by

    add_index :comments, :story_id
    add_index :comments, :comment_by
  end
end
