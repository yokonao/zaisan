class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :account_type, null: false
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
