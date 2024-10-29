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

ActiveRecord::Schema[7.2].define(version: 2024_10_29_160118) do
  create_table "churches", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "neighborhood"
    t.string "timezone"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_churches_on_latitude_and_longitude"
    t.index ["name"], name: "index_churches_on_name"
  end

  create_table "confession_schedules", force: :cascade do |t|
    t.integer "church_id", null: false
    t.integer "day_of_week"
    t.time "start_time"
    t.time "end_time"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["church_id", "day_of_week"], name: "index_confession_schedules_on_church_id_and_day_of_week"
    t.index ["church_id"], name: "index_confession_schedules_on_church_id"
  end

  create_table "mass_schedules", force: :cascade do |t|
    t.integer "church_id", null: false
    t.integer "day_of_week"
    t.time "start_time"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["church_id", "day_of_week"], name: "index_mass_schedules_on_church_id_and_day_of_week"
    t.index ["church_id"], name: "index_mass_schedules_on_church_id"
  end

  add_foreign_key "confession_schedules", "churches"
  add_foreign_key "mass_schedules", "churches"
end
