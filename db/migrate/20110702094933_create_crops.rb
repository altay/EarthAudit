class CreateCrops < ActiveRecord::Migration
  def self.up
    create_table :crops do |t|
      t.string  :name
      t.timestamps
    end
    add_index :crops, :name
  end

  def self.down
    remove_index :crops, :column => :name
    drop_table :crops
  end
end
