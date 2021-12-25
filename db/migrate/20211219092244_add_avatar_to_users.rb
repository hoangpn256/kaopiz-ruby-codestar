class AddAvatarToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :avatar , :attachment
  end
end
