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

ActiveRecord::Schema.define(version: 20160506094437) do

  create_table "activities", force: :cascade do |t|
    t.integer  "aircraft_id",              limit: 4
    t.integer  "departure_airport_id",     limit: 4
    t.integer  "arrival_airport_id",       limit: 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.boolean  "empty_leg",                              default: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "trip_id",                  limit: 4
    t.integer  "pax",                      limit: 4
    t.float    "flight_cost",              limit: 24,    default: 0.0
    t.float    "handling_cost_at_takeoff", limit: 24,    default: 0.0
    t.float    "landing_cost_at_arrival",  limit: 24,    default: 0.0
    t.text     "accommodation_plan",       limit: 65535
    t.datetime "deleted_at"
    t.boolean  "watch_hour_at_arrival",                  default: false
    t.float    "watch_hour_cost",          limit: 24,    default: 0.0
    t.float    "empty_leg_whole_price",    limit: 24,    default: 0.0
    t.float    "empty_leg_seat_price",     limit: 24,    default: 0.0
  end

  create_table "admin_roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "admin_roleships", force: :cascade do |t|
    t.integer  "admin_id",      limit: 4
    t.integer  "admin_role_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "aircraft_images", force: :cascade do |t|
    t.integer  "aircraft_id",        limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
  end

  create_table "aircraft_types", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "svg",          limit: 16777215
    t.float    "speed_in_kts", limit: 24
    t.text     "description",  limit: 65535
  end

  create_table "aircraft_unavailabilities", force: :cascade do |t|
    t.integer  "aircraft_id", limit: 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "reason",      limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
  end

  create_table "aircrafts", force: :cascade do |t|
    t.string   "tail_number",                  limit: 255
    t.integer  "aircraft_type_id",             limit: 4
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "seating_capacity",             limit: 4
    t.integer  "baggage_capacity_in_kg",       limit: 4
    t.integer  "landing_field_length_in_feet", limit: 4
    t.integer  "runway_field_length_in_feet",  limit: 4
    t.integer  "number_of_toilets",            limit: 4
    t.float    "cabin_width_in_meters",        limit: 24
    t.float    "cabin_height_in_meters",       limit: 24
    t.float    "cabin_length_in_meters",       limit: 24
    t.string   "memorable_name",               limit: 255
    t.integer  "crew",                         limit: 4
    t.boolean  "wifi"
    t.boolean  "phone"
    t.boolean  "flight_attendant",                         default: false
    t.string   "year_of_manufacture",          limit: 255
    t.boolean  "medical_evac",                             default: false
    t.float    "cruise_speed_in_nm_per_hour",  limit: 24
    t.float    "flying_range_in_nm",           limit: 24
    t.float    "per_hour_cost",                limit: 24
    t.boolean  "admin_verified",                           default: false
    t.integer  "organisation_id",              limit: 4
    t.integer  "base_airport_id",              limit: 4
    t.datetime "deleted_at"
  end

  create_table "airports", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.integer  "city_id",                     limit: 4
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.float    "longitude",                   limit: 24
    t.float    "latitude",                    limit: 24
    t.string   "code",                        limit: 255
    t.boolean  "private_landing"
    t.boolean  "international"
    t.boolean  "night_landing"
    t.boolean  "night_parking"
    t.string   "ifr_or_vfr",                  limit: 255
    t.boolean  "fuel_availability"
    t.boolean  "watch_hour_extension"
    t.string   "icao_code",                   limit: 255
    t.float    "runway_field_length_in_feet", limit: 24
    t.float    "landing_cost",                limit: 24,  default: 0.0
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "state",                 limit: 255
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "image_file_name",       limit: 255
    t.string   "image_content_type",    limit: 255
    t.integer  "image_file_size",       limit: 4
    t.datetime "image_updated_at"
    t.string   "accomodation_category", limit: 255
  end

  create_table "contact_details", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.text     "message",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "distances", force: :cascade do |t|
    t.integer  "from_airport_id", limit: 4
    t.integer  "to_airport_id",   limit: 4
    t.float    "distance_in_nm",  limit: 24
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "forum_topic_comments", force: :cascade do |t|
    t.text     "comment",         limit: 65535
    t.integer  "forum_topic_id",  limit: 4
    t.integer  "operator_id",     limit: 4
    t.integer  "organisation_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "forum_topics", force: :cascade do |t|
    t.string   "statement",       limit: 255
    t.text     "description",     limit: 65535
    t.integer  "operator_id",     limit: 4
    t.integer  "organisation_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "jetsteal_seats", force: :cascade do |t|
    t.integer  "jetsteal_id",            limit: 4
    t.string   "ui_seat_id",             limit: 255
    t.boolean  "disabled",                           default: false
    t.integer  "cost",                   limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "payment_transaction_id", limit: 4
    t.datetime "locked_at"
    t.integer  "orientation",            limit: 4
    t.string   "seat_type",              limit: 255
  end

  create_table "jetsteal_subscriptions", force: :cascade do |t|
    t.string   "email",             limit: 255
    t.string   "name",              limit: 255
    t.string   "phone",             limit: 255
    t.boolean  "send_emails"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "date",              limit: 255
    t.string   "departure_airport", limit: 255
    t.string   "arrival_airport",   limit: 255
    t.string   "pax",               limit: 255
  end

  create_table "jetsteals", force: :cascade do |t|
    t.integer  "departure_airport_id",       limit: 4
    t.integer  "arrival_airport_id",         limit: 4
    t.integer  "aircraft_id",                limit: 4
    t.boolean  "sell_by_seats",                        default: true
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "cost",                       limit: 4
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "launched",                             default: false
    t.integer  "flight_duration_in_minutes", limit: 4
    t.boolean  "email_sent",                           default: false
    t.datetime "deleted_at"
  end

  create_table "jsg_updates", force: :cascade do |t|
    t.text     "title",       limit: 65535
    t.text     "description", limit: 65535
    t.text     "source_url",  limit: 65535
    t.text     "image_url",   limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
  end

  create_table "key_value_pairs", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.text     "value",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "notams", force: :cascade do |t|
    t.integer  "airport_id", limit: 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "organisation_documents", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "category",        limit: 255
    t.string   "doc_type",        limit: 255
    t.integer  "organisation_id", limit: 4
    t.integer  "static_file_id",  limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.boolean  "admin_verified",                    default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.text     "terms_and_condition", limit: 65535
    t.string   "image_file_name",     limit: 255
    t.string   "image_content_type",  limit: 255
    t.integer  "image_file_size",     limit: 4
    t.datetime "image_updated_at"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.integer  "contact_id",         limit: 4
    t.string   "status",             limit: 255,   default: "pending"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "processor_response", limit: 65535
    t.float    "amount",             limit: 24
    t.string   "billing_address",    limit: 255
    t.string   "billing_city",       limit: 255
    t.string   "billing_state",      limit: 255
    t.string   "billing_zip",        limit: 255
    t.string   "billing_country",    limit: 255
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                    limit: 255,               null: false
    t.string   "environment",             limit: 255
    t.text     "certificate",             limit: 65535
    t.string   "password",                limit: 255
    t.integer  "connections",             limit: 4,     default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                    limit: 255,               null: false
    t.string   "auth_key",                limit: 255
    t.string   "client_id",               limit: 255
    t.string   "client_secret",           limit: 255
    t.string   "access_token",            limit: 255
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id",       limit: 4
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge",             limit: 4
    t.string   "device_token",      limit: 64
    t.string   "sound",             limit: 255,      default: "default"
    t.text     "alert",             limit: 65535
    t.text     "data",              limit: 65535
    t.integer  "expiry",            limit: 4,        default: 86400
    t.boolean  "delivered",                          default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                             default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code",        limit: 4
    t.text     "error_description", limit: 65535
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                      default: false
    t.string   "type",              limit: 255,                          null: false
    t.string   "collapse_key",      limit: 255
    t.boolean  "delay_while_idle",                   default: false,     null: false
    t.text     "registration_ids",  limit: 16777215
    t.integer  "app_id",            limit: 4,                            null: false
    t.integer  "retries",           limit: 4,        default: 0
    t.string   "uri",               limit: 255
    t.datetime "fail_after"
    t.boolean  "processing",                         default: false,     null: false
    t.integer  "priority",          limit: 4
    t.text     "url_args",          limit: 65535
    t.string   "category",          limit: 255
    t.boolean  "content_available",                  default: false
    t.text     "notification",      limit: 65535
  end

  add_index "rpush_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree
  add_index "rpush_notifications", ["delivered", "failed"], name: "index_rpush_notifications_multi", using: :btree

  create_table "search_activities", force: :cascade do |t|
    t.integer  "search_id",            limit: 4
    t.integer  "departure_airport_id", limit: 4
    t.integer  "arrival_airport_id",   limit: 4
    t.datetime "start_at"
    t.integer  "pax",                  limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "searches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "static_files", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.integer  "file_file_size",    limit: 4
    t.datetime "file_updated_at"
  end

  create_table "taxes", force: :cascade do |t|
    t.float    "service_tax",        limit: 24
    t.float    "swachh_bharat_cess", limit: 24
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "terms_and_conditions", force: :cascade do |t|
    t.text     "description",     limit: 65535
    t.integer  "organisation_id", limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "trips", force: :cascade do |t|
    t.integer  "organisation_id",        limit: 4
    t.string   "status",                 limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "user_id",                limit: 4
    t.integer  "payment_transaction_id", limit: 4
    t.datetime "deleted_at"
    t.string   "payment_status",         limit: 255, default: "unpaid"
    t.float    "amount_paid",            limit: 24,  default: 0.0
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    limit: 255,   default: "",    null: false
    t.string   "encrypted_password",       limit: 255,   default: "",    null: false
    t.string   "reset_password_token",     limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            limit: 4,     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",       limit: 255
    t.string   "last_sign_in_ip",          limit: 255
    t.string   "first_name",               limit: 255
    t.string   "last_name",                limit: 255
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "type",                     limit: 255
    t.string   "phone",                    limit: 255
    t.boolean  "approved_by_admin",                      default: false
    t.text     "roles",                    limit: 65535
    t.integer  "organisation_id",          limit: 4
    t.text     "api_token",                limit: 65535
    t.string   "designation",              limit: 255
    t.datetime "deleted_at"
    t.string   "ios_app_devise_token",     limit: 255
    t.string   "android_app_devise_token", limit: 255
    t.boolean  "send_app_notifications",                 default: true
    t.string   "image_file_name",          limit: 255
    t.string   "image_content_type",       limit: 255
    t.integer  "image_file_size",          limit: 4
    t.datetime "image_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,        null: false
    t.integer  "item_id",    limit: 4,          null: false
    t.string   "event",      limit: 255,        null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "watch_hours", force: :cascade do |t|
    t.integer  "airport_id", limit: 4
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

end
