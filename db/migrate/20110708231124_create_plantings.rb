class CreatePlantings < ActiveRecord::Migration
  def self.up
    create_table :plantings do |t|  # join table between grid cells and crops
      t.integer :grid_cell_id
      t.integer :crop_id
      t.datetime :planting_start
      t.datetime :planting_end
      t.datetime :harvest_start
      t.datetime :harvest_end
      t.timestamps
    end
    add_index :plantings, :grid_cell_id
    add_index :plantings, :crop_id
  end

  def self.down
    remove_index :plantings, :column => :crop_id
    remove_index :plantings, :column => :grid_cell_id
    drop_table :plantings 
  end
end
