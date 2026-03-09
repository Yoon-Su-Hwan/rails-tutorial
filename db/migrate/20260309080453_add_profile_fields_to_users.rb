class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string
    add_column :users, :birthdate, :date
    add_column :users, :phone_number, :string
    add_column :users, :address, :string
  end
end
