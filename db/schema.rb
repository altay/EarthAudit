# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110708231124) do

  create_table "climate_reports", :force => true do |t|
    t.integer  "grid_cell_id"
    t.integer  "month"
    t.integer  "year"
    t.float    "precipitation"
    t.float    "temperature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "climate_reports", ["grid_cell_id"], :name => "index_climate_reports_on_grid_cell_id"
  add_index "climate_reports", ["month", "year"], :name => "index_climate_reports_on_month_and_year"

  create_table "crops", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "crops", ["name"], :name => "index_crops_on_name"

  create_table "grid_cells", :force => true do |t|
    t.integer  "fid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.polygon  "the_geom",   :limit => nil, :null => false, :srid => 4326
  end

  add_index "grid_cells", ["fid"], :name => "index_grid_cells_on_fid"
  add_index "grid_cells", ["the_geom"], :name => "index_grid_cells_on_the_geom", :spatial => true

  create_table "plantings", :force => true do |t|
    t.integer  "grid_cell_id"
    t.integer  "crop_id"
    t.datetime "planting_start"
    t.datetime "planting_end"
    t.datetime "harvest_start"
    t.datetime "harvest_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plantings", ["crop_id"], :name => "index_plantings_on_crop_id"
  add_index "plantings", ["grid_cell_id"], :name => "index_plantings_on_grid_cell_id"

end
