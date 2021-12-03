class CreateComment < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.string :user_id
      t.string :int
      t.text :content

      t.timestamps
    end
  end
end
