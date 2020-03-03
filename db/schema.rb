# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200303135034) do

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.string "article_type"
    t.integer "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_type", "article_id"], name: "index_comments_on_article_type_and_article_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.integer "number"
    t.string "travel_type"
    t.text "directions"
    t.string "address"
    t.integer "trip_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_stages_on_trip_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.string "categories"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
  end

end
