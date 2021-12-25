class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.date :dob
      t.references :user, null: false, foreign_key: true
      t.string :phone

      t.timestamps
    end
  end
end
