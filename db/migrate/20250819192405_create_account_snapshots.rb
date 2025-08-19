class CreateAccountSnapshots < ActiveRecord::Migration[8.0]
  def change
    create_table :account_snapshots do |t|
      t.references :account, null: false, foreign_key: true
      t.integer :amount, null: false
      t.datetime :recorded_at, null: false

      t.timestamps
    end

    add_index :account_snapshots, [ :account_id, :recorded_at ], order: { recorded_at: :desc }
    add_index :account_snapshots, :recorded_at, order: { recorded_at: :desc }
  end
end
