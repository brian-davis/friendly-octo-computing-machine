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

ActiveRecord::Schema[7.1].define(version: 2024_08_23_201941) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "notes", force: :cascade do |t|
    t.text "text"
    t.bigint "work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id"], name: "index_notes_on_work_id"
  end

  create_table "producers", force: :cascade do |t|
    t.string "custom_name"
    t.string "forename"
    t.string "middle_name"
    t.string "surname"
    t.string "foreign_name"
    t.string "bio_link"
    t.string "nationality"
    t.integer "year_of_birth"
    t.integer "year_of_death"
    t.integer "works_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "searchable", type: :tsvector, as: "(((setweight(to_tsvector('english'::regconfig, (COALESCE(custom_name, ''::character varying))::text), 'A'::\"char\") || setweight(to_tsvector('english'::regconfig, (COALESCE(forename, ''::character varying))::text), 'B'::\"char\")) || setweight(to_tsvector('english'::regconfig, (COALESCE(surname, ''::character varying))::text), 'C'::\"char\")) || setweight(to_tsvector('english'::regconfig, (COALESCE(foreign_name, ''::character varying))::text), 'D'::\"char\"))", stored: true
    t.index ["searchable"], name: "index_producers_on_searchable", using: :gin
    t.unique_constraint ["forename", "surname", "year_of_birth"], deferrable: :immediate, name: "producers_forename_surname_year_of_birth_unique"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.integer "works_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false

    t.check_constraint "name IS NOT NULL AND name::text !~ '^\\s*$'::text", name: "publishers_name_presence"
    t.unique_constraint ["name"], deferrable: :deferred, name: "publishers_name_unique"
  end

  create_table "quotes", force: :cascade do |t|
    t.text "text"
    t.string "page"
    t.string "custom_citation"
    t.bigint "work_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "searchable", type: :tsvector, as: "setweight(to_tsvector('english'::regconfig, COALESCE(text, ''::text)), 'A'::\"char\")", stored: true
    t.index ["searchable"], name: "index_quotes_on_searchable", using: :gin
    t.index ["work_id"], name: "index_quotes_on_work_id"
  end

  create_table "reading_sessions", force: :cascade do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.bigint "work_id", null: false
    t.integer "pages"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["work_id"], name: "index_reading_sessions_on_work_id"
  end

  create_table "work_producers", force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "producer_id", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["producer_id"], name: "index_work_producers_on_producer_id"
    t.index ["role"], name: "index_work_producers_on_role"
    t.index ["work_id"], name: "index_work_producers_on_work_id"
    t.unique_constraint ["work_id", "producer_id", "role"], deferrable: :deferred, name: "work_producers_work_id_producer_id_role_unique"
  end

  create_table "works", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.string "supertitle"
    t.string "alternate_title"
    t.string "foreign_title"
    t.string "custom_citation"
    t.text "accession_note"
    t.string "tags", default: [], array: true
    t.integer "format", default: 0
    t.string "language"
    t.string "original_language"
    t.bigint "parent_id"
    t.integer "rating"
    t.integer "year_of_composition"
    t.integer "year_of_publication"
    t.date "date_of_completion"
    t.date "date_of_accession"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "publisher_id"
    t.virtual "searchable", type: :tsvector, as: "(((setweight(to_tsvector('english'::regconfig, (COALESCE(title, ''::character varying))::text), 'A'::\"char\") || setweight(to_tsvector('english'::regconfig, (COALESCE(subtitle, ''::character varying))::text), 'B'::\"char\")) || setweight(to_tsvector('english'::regconfig, (COALESCE(supertitle, ''::character varying))::text), 'C'::\"char\")) || setweight(to_tsvector('english'::regconfig, (COALESCE(foreign_title, ''::character varying))::text), 'D'::\"char\"))", stored: true
    t.index ["format"], name: "index_works_on_format"
    t.index ["parent_id"], name: "index_works_on_parent_id"
    t.index ["publisher_id"], name: "index_works_on_publisher_id"
    t.index ["searchable"], name: "index_works_on_searchable", using: :gin
    t.index ["tags"], name: "index_works_on_tags", using: :gin
  end

  add_foreign_key "notes", "works"
  add_foreign_key "quotes", "works"
  add_foreign_key "reading_sessions", "works"
  add_foreign_key "work_producers", "producers"
  add_foreign_key "work_producers", "works"
  add_foreign_key "works", "publishers"
  add_foreign_key "works", "works", column: "parent_id"
end
