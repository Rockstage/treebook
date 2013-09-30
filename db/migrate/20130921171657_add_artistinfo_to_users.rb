class AddArtistinfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :artist_name, :string
    add_column :users, :genre, :string
    add_column :users, :bio, :text
    add_column :users, :members, :string
    add_column :users, :influence, :text
    add_column :users, :soundslike, :text
    add_column :users, :contacts, :string
  end
end
