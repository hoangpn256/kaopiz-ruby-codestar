class CreateUserDeleteHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :user_delete_histories do |t|
      t.string :email
      t.string :name
      t.datetime :dob
      t.string :address

      t.timestamps
    end
  end
end
