# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_19_192405) do
  create_table "account_snapshots", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "amount", null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "recorded_at"], name: "index_account_snapshots_on_account_id_and_recorded_at", order: { recorded_at: :desc }
    t.index ["account_id"], name: "index_account_snapshots_on_account_id"
    t.index ["recorded_at"], name: "index_account_snapshots_on_recorded_at", order: :desc
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "account_type", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "account_snapshots", "accounts"
  add_foreign_key "accounts", "users"
end
