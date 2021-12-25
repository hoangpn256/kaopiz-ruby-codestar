class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :viewed
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
