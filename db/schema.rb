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

ActiveRecord::Schema[7.0].define(version: 2022_07_24_162946) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "belonging_infos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "office_id"
    t.integer "status_id"
    t.integer "default_price"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_belonging_infos_on_office_id"
    t.index ["user_id"], name: "index_belonging_infos_on_user_id"
  end

  create_table "charges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "matter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_charges_on_matter_id"
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "client_joins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "office_id"
    t.bigint "user_id"
    t.bigint "client_id", null: false
    t.integer "belong_side_id", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_client_joins_on_client_id"
    t.index ["office_id"], name: "index_client_joins_on_office_id"
    t.index ["user_id"], name: "index_client_joins_on_user_id"
  end

  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "first_name"
    t.string "name_kana", null: false
    t.string "first_name_kana"
    t.string "maiden_name"
    t.string "maiden_name_kana"
    t.text "profile"
    t.string "indentification_number"
    t.date "birth_date"
    t.integer "client_type_id", null: false
    t.boolean "archive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "category", null: false
    t.string "memo"
    t.string "post_code"
    t.string "prefecture"
    t.string "address"
    t.string "building_name"
    t.boolean "send_by_personal", default: false
    t.bigint "client_id"
    t.bigint "opponent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contact_addresses_on_client_id"
    t.index ["opponent_id"], name: "index_contact_addresses_on_opponent_id"
  end

  create_table "contact_emails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "category", null: false
    t.string "memo"
    t.string "email"
    t.bigint "client_id"
    t.bigint "opponent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contact_emails_on_client_id"
    t.index ["opponent_id"], name: "index_contact_emails_on_opponent_id"
  end

  create_table "contact_phone_numbers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "category", null: false
    t.string "memo"
    t.string "phone_number"
    t.bigint "client_id"
    t.bigint "opponent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contact_phone_numbers_on_client_id"
    t.index ["opponent_id"], name: "index_contact_phone_numbers_on_opponent_id"
  end

  create_table "fees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "fee_type_id", null: false
    t.integer "price", null: false
    t.text "description"
    t.date "deadline"
    t.integer "pay_times", null: false
    t.integer "monthly_date_id"
    t.integer "current_payment"
    t.integer "price_type", null: false
    t.date "paid_date"
    t.integer "paid_amount"
    t.boolean "pay_off", default: false, null: false
    t.boolean "archive", default: true, null: false
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_fees_on_matter_id"
  end

  create_table "invite_urls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "token", null: false
    t.boolean "admin", default: false
    t.datetime "limit_date", null: false
    t.boolean "join", default: false
    t.bigint "user_id", null: false
    t.bigint "client_id"
    t.bigint "matter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invite_urls_on_client_id"
    t.index ["matter_id"], name: "index_invite_urls_on_matter_id"
    t.index ["user_id"], name: "index_invite_urls_on_user_id"
  end

  create_table "matter_assigns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "matter_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_assigns_on_matter_id"
    t.index ["user_id"], name: "index_matter_assigns_on_user_id"
  end

  create_table "matter_categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matter_category_joins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "matter_id", null: false
    t.bigint "matter_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_category_id"], name: "index_matter_category_joins_on_matter_category_id"
    t.index ["matter_id"], name: "index_matter_category_joins_on_matter_id"
  end

  create_table "matter_joins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "office_id"
    t.bigint "user_id"
    t.bigint "matter_id", null: false
    t.integer "belong_side_id", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_joins_on_matter_id"
    t.index ["office_id"], name: "index_matter_joins_on_office_id"
    t.index ["user_id"], name: "index_matter_joins_on_user_id"
  end

  create_table "matter_tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "matter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_matter_tags_on_matter_id"
    t.index ["tag_id"], name: "index_matter_tags_on_tag_id"
  end

  create_table "matters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "client_id", null: false
    t.integer "service_price"
    t.text "description"
    t.date "start_date"
    t.date "finish_date"
    t.integer "matter_status_id", null: false
    t.boolean "archive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_matters_on_client_id"
    t.index ["user_id"], name: "index_matters_on_user_id"
  end

  create_table "offices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number", null: false
    t.string "post_code"
    t.string "prefecture"
    t.string "address"
    t.boolean "archive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "opponents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_kana", null: false
    t.string "first_name"
    t.string "first_name_kana"
    t.string "maiden_name"
    t.string "maiden_name_kana"
    t.text "profile"
    t.date "birth_date"
    t.integer "opponent_relation_type", null: false
    t.bigint "matter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_opponents_on_matter_id"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_assigns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_assigns_on_task_id"
    t.index ["user_id"], name: "index_task_assigns_on_user_id"
  end

  create_table "task_template_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "office_id"
    t.bigint "matter_category_id", null: false
    t.string "name"
    t.text "description"
    t.boolean "public_flg", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_category_id"], name: "index_task_template_groups_on_matter_category_id"
    t.index ["office_id"], name: "index_task_template_groups_on_office_id"
    t.index ["user_id"], name: "index_task_template_groups_on_user_id"
  end

  create_table "task_templates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "work_stage_id", null: false
    t.bigint "task_template_group_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_template_group_id"], name: "index_task_templates_on_task_template_group_id"
    t.index ["work_stage_id"], name: "index_task_templates_on_work_stage_id"
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "start_datetime"
    t.datetime "finish_datetime"
    t.integer "task_status", null: false
    t.integer "priority", null: false
    t.text "description"
    t.boolean "complete", default: false, null: false
    t.boolean "archive", default: true, null: false
    t.bigint "user_id", null: false
    t.bigint "matter_id"
    t.bigint "work_stage_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_id"], name: "index_tasks_on_matter_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
    t.index ["work_stage_id"], name: "index_tasks_on_work_stage_id"
  end

  create_table "user_invites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "sender_id", null: false
    t.string "token", null: false
    t.datetime "limit_date", null: false
    t.boolean "join", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.string "salt"
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.integer "membership_number"
    t.integer "user_job_id", null: false
    t.integer "office_id"
    t.boolean "archive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

  create_table "work_stages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "matter_category_id", null: false
    t.string "name"
    t.boolean "archive", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["matter_category_id"], name: "index_work_stages_on_matter_category_id"
    t.index ["user_id"], name: "index_work_stages_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "belonging_infos", "offices"
  add_foreign_key "belonging_infos", "users"
  add_foreign_key "charges", "matters"
  add_foreign_key "charges", "users"
  add_foreign_key "client_joins", "clients"
  add_foreign_key "client_joins", "offices"
  add_foreign_key "client_joins", "users"
  add_foreign_key "contact_addresses", "clients"
  add_foreign_key "contact_addresses", "opponents"
  add_foreign_key "contact_emails", "clients"
  add_foreign_key "contact_emails", "opponents"
  add_foreign_key "contact_phone_numbers", "clients"
  add_foreign_key "contact_phone_numbers", "opponents"
  add_foreign_key "fees", "matters"
  add_foreign_key "invite_urls", "clients"
  add_foreign_key "invite_urls", "matters"
  add_foreign_key "invite_urls", "users"
  add_foreign_key "matter_assigns", "matters"
  add_foreign_key "matter_assigns", "users"
  add_foreign_key "matter_category_joins", "matter_categories"
  add_foreign_key "matter_category_joins", "matters"
  add_foreign_key "matter_joins", "matters"
  add_foreign_key "matter_joins", "offices"
  add_foreign_key "matter_joins", "users"
  add_foreign_key "matter_tags", "matters"
  add_foreign_key "matter_tags", "tags"
  add_foreign_key "matters", "clients"
  add_foreign_key "matters", "users"
  add_foreign_key "opponents", "matters"
  add_foreign_key "task_assigns", "tasks"
  add_foreign_key "task_assigns", "users"
  add_foreign_key "task_template_groups", "matter_categories"
  add_foreign_key "task_template_groups", "offices"
  add_foreign_key "task_template_groups", "users"
  add_foreign_key "task_templates", "task_template_groups"
  add_foreign_key "task_templates", "work_stages"
  add_foreign_key "tasks", "matters"
  add_foreign_key "tasks", "users"
  add_foreign_key "tasks", "work_stages"
  add_foreign_key "work_stages", "matter_categories"
  add_foreign_key "work_stages", "users"
end
