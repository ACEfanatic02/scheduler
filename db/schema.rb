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

ActiveRecord::Schema.define(version: 20140414220920) do

  create_table "appointments", force: true do |t|
    t.integer  "tutor_id"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id"
    t.datetime "start_time"
    t.integer  "length"
  end

  add_index "appointments", ["start_time"], name: "index_appointments_on_start_time", unique: true

  create_table "clients", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string   "course_number"
    t.string   "course_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["course_number"], name: "index_subjects_on_course_number", unique: true

  create_table "subjects_tutors", id: false, force: true do |t|
    t.integer "subject_id"
    t.integer "tutor_id"
  end

  create_table "tutors", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
