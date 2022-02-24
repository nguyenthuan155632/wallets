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

ActiveRecord::Schema.define(version: 2022_02_24_014325) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "wallets", default: [], array: true
    t.text "note", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "networks", force: :cascade do |t|
    t.string "network_name", null: false
    t.integer "chain_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_networks_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.bigint "wallet_id", null: false
    t.bigint "network_id", null: false
    t.string "contract_name", null: false
    t.string "contract_ticker_symbol", null: false
    t.string "contract_address"
    t.string "logo_url"
    t.decimal "balance", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_name"], name: "index_tokens_on_contract_name"
    t.index ["network_id"], name: "index_tokens_on_network_id"
    t.index ["wallet_id"], name: "index_tokens_on_wallet_id"
  end

  create_table "trashes", force: :cascade do |t|
    t.string "contract_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_name"], name: "index_trashes_on_contract_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.string "address", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["address", "user_id"], name: "index_wallets_on_address_and_user_id", unique: true
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

end
