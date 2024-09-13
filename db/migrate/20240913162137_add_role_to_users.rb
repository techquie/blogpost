class AddRoleToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer
    add_column :users, :name, :string
    add_column :users, :active, :boolean, default: true
  end
end
