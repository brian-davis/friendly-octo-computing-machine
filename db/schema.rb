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

ActiveRecord::Schema[7.1].define(version: 2024_08_07_223430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "producers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "birth_year"
    t.integer "death_year"
    t.string "bio_link"
    t.string "nationality"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "work_producers", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "producer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["producer_id"], name: "index_work_producers_on_producer_id"
    t.index ["work_id"], name: "index_work_producers_on_work_id"
  end

  create_table "works", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "publisher_id"
    t.string "subtitle"
    t.string "alternate_title"
    t.string "foreign_title"
    t.integer "year_of_composition"
    t.integer "year_of_publication"
    t.string "language"
    t.string "original_language"
    t.index ["publisher_id"], name: "index_works_on_publisher_id"
  end

  add_foreign_key "work_producers", "producers"
  add_foreign_key "work_producers", "works"
  add_foreign_key "works", "publishers"
end
