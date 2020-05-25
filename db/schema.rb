# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_25_063714) do

  create_table "billers", force: :cascade do |t|
    t.string "contacts"
    t.string "from"
    t.text "error"
    t.datetime "created_at"
  end

  create_table "brands", force: :cascade do |t|
    t.integer "brand_code"
    t.string "brand_name"
    t.integer "biller_id"
  end

  create_table "emails", force: :cascade do |t|
    t.text "message"
    t.string "contacts"
  end

  create_table "products", force: :cascade do |t|
    t.integer "product_id"
    t.string "product_name"
    t.integer "brand_id"
  end

end
