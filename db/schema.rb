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

ActiveRecord::Schema.define(version: 20140805134104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "animal_activity_observation", force: true do |t|
    t.integer  "hunting_location_id",                    null: false
    t.integer  "animal_category_id",                     null: false
    t.integer  "animal_count",                 limit: 2, null: false
    t.integer  "animal_activity_type_id",                null: false
    t.integer  "hunting_plot_named_animal_id"
    t.datetime "observation_date_time",                  null: false
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animal_activity_observation", ["animal_activity_type_id"], :name => "index_animal_activity_observation_on_animal_activity_type_id"
  add_index "animal_activity_observation", ["animal_category_id"], :name => "index_animal_activity_observation_on_animal_category_id"
  add_index "animal_activity_observation", ["hunting_location_id"], :name => "index_animal_activity_observation_on_hunting_location_id"

  create_table "animal_activity_type", force: true do |t|
    t.string   "name",       limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "animal_category", force: true do |t|
    t.integer  "animal_species_id",             null: false
    t.string   "name",              limit: 100, null: false
    t.integer  "gender",            limit: 2,   null: false
    t.integer  "maturity",          limit: 2,   null: false
    t.integer  "trophy_rating",     limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "animal_category", ["animal_species_id"], :name => "index_animal_category_on_animal_species_id"

  create_table "animal_species", force: true do |t|
    t.string   "common_name", limit: 100, null: false
    t.string   "species",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "composite_network_member", force: true do |t|
    t.integer  "composite_network_id", null: false
    t.integer  "member_network_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "composite_network_member", ["composite_network_id", "member_network_id"], :name => "idx_composite_network_member_on_composite_and_member_networks", :unique => true
  add_index "composite_network_member", ["composite_network_id"], :name => "index_composite_network_member_on_composite_network_id"
  add_index "composite_network_member", ["member_network_id"], :name => "index_composite_network_member_on_member_network_id"

  create_table "hunting_location", force: true do |t|
    t.integer  "hunting_plot_id",                                                          null: false
    t.string   "name",            limit: 100,                                              null: false
    t.spatial  "coordinates",     limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
    t.integer  "location_type",                                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hunting_location", ["hunting_plot_id"], :name => "index_hunting_location_on_hunting_plot_id"

  create_table "hunting_plot", force: true do |t|
    t.string   "name",                 limit: 100,                                              null: false
    t.string   "location_address",                                                              null: false
    t.spatial  "location_coordinates", limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "boundary",             limit: {:srid=>4326, :type=>"polygon"}
  end

  create_table "hunting_plot_named_animal", force: true do |t|
    t.integer  "hunting_plot_id",                null: false
    t.string   "name",               limit: 100, null: false
    t.integer  "animal_category_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hunting_plot_named_animal", ["animal_category_id"], :name => "index_hunting_plot_named_animal_on_animal_category_id"
  add_index "hunting_plot_named_animal", ["hunting_plot_id"], :name => "index_hunting_plot_named_animal_on_hunting_plot_id"

  create_table "hunting_plot_user_access", force: true do |t|
    t.integer  "user_id",                                 null: false
    t.integer  "hunting_plot_id",                         null: false
    t.string   "alias",           limit: 100
    t.integer  "permissions",                 default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hunting_plot_user_access", ["hunting_plot_id"], :name => "index_hunting_plot_user_access_on_hunting_plot_id"
  add_index "hunting_plot_user_access", ["user_id", "hunting_plot_id"], :name => "index_hunting_plot_user_access_on_user_id_and_hunting_plot_id", :unique => true
  add_index "hunting_plot_user_access", ["user_id"], :name => "index_hunting_plot_user_access_on_user_id"

  create_table "relationship_request", force: true do |t|
    t.integer  "created_by_id",   null: false
    t.integer  "related_user_id", null: false
    t.integer  "status",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationship_request", ["created_by_id"], :name => "index_relationship_request_on_created_by_id"
  add_index "relationship_request", ["related_user_id"], :name => "index_relationship_request_on_related_user_id"

  create_table "user", force: true do |t|
    t.string   "first_name",            limit: 100,                 null: false
    t.string   "last_name",             limit: 100,                 null: false
    t.string   "alias",                 limit: 100
    t.string   "email",                 limit: 254,                 null: false
    t.string   "password_digest",                                   null: false
    t.string   "remember_token"
    t.integer  "authentication_method",             default: 1,     null: false
    t.boolean  "admin",                             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_network", force: true do |t|
    t.string   "name",              limit: 100, null: false
    t.integer  "category_id",                   null: false
    t.integer  "parent_network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_network", ["category_id"], :name => "index_user_network_on_category_id"
  add_index "user_network", ["parent_network_id"], :name => "index_user_network_on_parent_network_id"

  create_table "user_network_boundary", force: true do |t|
    t.integer  "user_network_id",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "boundary",        limit: {:srid=>4326, :type=>"polygon"}
  end

  add_index "user_network_boundary", ["boundary"], :name => "index_user_network_boundary_on_boundary", :spatial => true
  add_index "user_network_boundary", ["user_network_id"], :name => "index_user_network_boundary_on_user_network_id"

  create_table "user_network_category", force: true do |t|
    t.string   "name",               limit: 100, null: false
    t.boolean  "is_composite",                   null: false
    t.integer  "parent_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_network_category", ["parent_category_id"], :name => "index_user_network_category_on_parent_category_id"

  create_table "user_network_subscription", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "user_network_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_network_subscription", ["user_id", "user_network_id"], :name => "idx_user_network_subscription_on_user_and_network", :unique => true
  add_index "user_network_subscription", ["user_id"], :name => "index_user_network_subscription_on_user_id"
  add_index "user_network_subscription", ["user_network_id"], :name => "index_user_network_subscription_on_user_network_id"

  create_table "user_post", force: true do |t|
    t.integer  "created_by_id",              null: false
    t.string   "post_content",  limit: 1000, null: false
    t.integer  "visibility",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_post", ["created_by_id"], :name => "index_user_post_on_created_by_id"

  create_table "user_relationship", force: true do |t|
    t.integer  "owning_user_id",              null: false
    t.integer  "related_user_id",             null: false
    t.integer  "relationship_type", limit: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_relationship", ["owning_user_id", "related_user_id"], :name => "index_user_relationship_on_owning_user_id_and_related_user_id", :unique => true

end
