class AddPersonalinfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :datetime
    add_column :users, :gender, :string
    add_column :users, :location, :string
    add_column :users, :about, :text
    add_column :users, :music, :text
    add_column :users, :character, :text
    add_column :users, :interests, :text
    add_column :users, :relationship, :string
  end
end
