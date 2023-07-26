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

ActiveRecord::Schema[7.0].define(version: 2023_07_24_180944) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.integer "activity_type", default: 0
    t.bigint "user_id"
    t.bigint "container_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id"], name: "index_activities_on_container_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "activity_repair_lists", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.bigint "repair_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comments"
    t.index ["activity_id"], name: "index_activity_repair_lists_on_activity_id"
    t.index ["repair_list_id"], name: "index_activity_repair_lists_on_repair_list_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "container_id"
    t.index ["container_id"], name: "index_comments_on_container_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "container_attachments", force: :cascade do |t|
    t.integer "photo_type", default: 0
    t.bigint "container_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id"], name: "index_container_attachments_on_container_id"
  end

  create_table "containers", force: :cascade do |t|
    t.string "yard_name"
    t.string "container_number"
    t.string "customer_name"
    t.string "container_owner_name"
    t.string "submitter_initials"
    t.float "container_length"
    t.float "container_height"
    t.string "container_type"
    t.datetime "container_manufacture_year"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "owner_name"
    t.string "billing_name"
    t.float "hourly_rate"
    t.float "gst"
    t.float "pst"
    t.string "city"
    t.string "address"
    t.string "province"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "repair_list", default: 0
    t.integer "status", default: 0
    t.string "password"
  end

  create_table "logs", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "old_status"
    t.string "new_status"
    t.index ["activity_id"], name: "index_logs_on_activity_id"
  end

  create_table "merc_repair_types", force: :cascade do |t|
    t.integer "max_min_cost"
    t.integer "unit_max_cost"
    t.integer "hours_per_cost"
    t.integer "max_pieces"
    t.integer "units"
    t.string "repair_mode"
    t.integer "mode_number"
    t.integer "repair_code"
    t.string "combined"
    t.string "description"
    t.integer "id_source"
    t.bigint "repair_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repair_list_id"], name: "index_merc_repairs_on_container_id"
  end

  create_table "non_maersk_repairs", force: :cascade do |t|
    t.integer "hours"
    t.float "material_cost"
    t.string "container_section"
    t.string "damaged_area"
    t.integer "repair_type"
    t.string "description"
    t.string "comp"
    t.string "dam"
    t.string "rep"
    t.string "component"
    t.string "event"
    t.string "location"
    t.string "area"
    t.string "area2"
    t.integer "id_source"
    t.bigint "repair_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repair_list_id"], name: "index_non_maersk_repairs_on_repair_list_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.string "scopes"
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "repair_list_attachments", force: :cascade do |t|
    t.bigint "activity_repair_list_id", null: false
    t.integer "photo_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_repair_list_id"], name: "index_repair_list_attachments_on_activity_repair_list_id"
  end

  create_table "repair_lists", force: :cascade do |t|
    t.string "container_repair_area"
    t.string "container_damaged_area"
    t.integer "repair_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "version"
    t.string "repair_number"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "phone_number"
    t.integer "status", default: 0
    t.integer "role", default: 0
    t.boolean "is_deleted", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "containers"
  add_foreign_key "activities", "users"
  add_foreign_key "activity_repair_lists", "activities"
  add_foreign_key "activity_repair_lists", "repair_lists"
  add_foreign_key "comments", "users"
  add_foreign_key "container_attachments", "containers"
  add_foreign_key "containers", "customers"
  add_foreign_key "logs", "activities"
  add_foreign_key "merc_repair_types", "repair_lists"
  add_foreign_key "non_maersk_repairs", "repair_lists"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "repair_list_attachments", "activity_repair_lists"
end
