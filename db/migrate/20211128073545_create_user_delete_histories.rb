class CreateUserDeleteHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :user_delete_histories do |t|
      t.string :email
      t.string :name
      t.date :dob
      t.string :address
      t.string :note

      t.timestamps
    end
  end
end
