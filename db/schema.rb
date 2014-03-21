# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140321111225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "hunting_locations", force: true do |t|
    t.integer  "hunting_plot_id"
    t.string   "name"
    t.integer  "hunting_plot"
    t.integer  "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "coordinates",     limit: {:srid=>0, :type=>"point"}
  end

  create_table "hunting_plots", force: true do |t|
    t.string   "name",                 limit: 100,                                              null: false
    t.spatial  "location_coordinates", limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "boundary",             limit: {:srid=>0, :type=>"polygon"}
  end

  create_table "users", force: true do |t|
    t.string   "first_name",            limit: 100, null: false
    t.string   "last_name",             limit: 100, null: false
    t.string   "alias",                 limit: 100
    t.string   "email",                 limit: 254, null: false
    t.string   "password_digest",                   null: false
    t.string   "remember_token"
    t.integer  "authentication_method",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
