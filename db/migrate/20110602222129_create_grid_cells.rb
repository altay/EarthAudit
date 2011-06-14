class CreateGridCells < ActiveRecord::Migration
  def self.up
    create_table :grid_cells do |t|
      t.integer    :fid
      t.polygon    :the_geom, :srid => 4326, :null => false
      t.timestamps
    end
    add_index :grid_cells, :fid
    add_index :grid_cells, :the_geom, :spatial => true
  end

  def self.down
    drop_table :grid_cells
  end
end
