class AddUserColumnToBookmark < ActiveRecord::Migration[6.1]
  def change
    add_reference :bookmarks, :user, null: false, foreign_key: true
  end
end
