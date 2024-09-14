class Stories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.string :content
      t.integer :user_id, null: false
      t.boolean :published, default: false

      t.timestamps
    end

    add_foreign_key :stories, :users
    add_index :stories, :user_id
  end
end
