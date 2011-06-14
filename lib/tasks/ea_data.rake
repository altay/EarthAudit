namespace :earthaudit do
  namespace :data do

    def ask(message)
      print(message)
      return STDIN.gets.chomp
    end

    desc "import grid cells"
    task(:import_gridcells=> :environment){|t|
      overwrite_existing_data = ask("Do you want to overwrite existing data? (y/n): ")
      while !['y','n'].member?(overwrite_existing_data)
        overwrite_existing_data = ask("Please type 'y' for yes or 'n' for no. ")
      end
      if overwrite_existing_data==='y'
        GridCell.destroy_all
      end
      row_count = FasterCSV.open("#{Rails.root}/lib/data/gridcells.csv", {:headers=>true}).count
      FasterCSV.open("#{Rails.root}/lib/data/gridcells.csv", {:headers=>true}).each_with_index{|row,i|
        puts("importing gridcell #{i+1} of #{row_count}")
        p=Polygon.from_coordinates([[
          [row["XUL"], row["YUL"]], 
          [row["XUR"], row["YUR"]], 
          [row["XLR"], row["YLR"]], 
          [row["XLL"], row["YLL"]], 
          [row["XUL"], row["YUL"]]
        ]], 4326)
        GridCell.create(:the_geom=>p, :fid=>row['FID'])
      }
=begin
      lats = (5..11)
      lons = (-3..2)
      latlons = []
      lats.each{|lat|
        lons.each{|lon|
          p=Polygon.from_coordinates([[[lon, lat], [lon, lat+1], [lon-1, lat+1], [lon-1, lat], [lon, lat]]], 4326)
          GridCell.create(:the_geom=>p)
        }
      }
=end

    }

  end
end
