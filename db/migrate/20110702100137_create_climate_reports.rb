class CreateClimateReports < ActiveRecord::Migration
  def self.up
    create_table :climate_reports do |t|
      t.integer :grid_cell_id
      t.integer :month
      t.integer :year
      t.float   :precipitation # mm/month
      t.float   :temperature   # degrees fahrenheit?
      t.timestamps
    end
    add_index :climate_reports, :grid_cell_id
    add_index :climate_reports, [:month, :year]
  end

  def self.down
    remove_index :climate_reports, :column => [:month, :year]
    remove_index :climate_reports, :column => :grid_cell_id
    drop_table :climate_reports
  end
end
