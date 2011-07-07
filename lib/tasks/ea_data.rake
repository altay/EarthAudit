namespace :earthaudit do
  namespace :data do

    def ask(message)
      print(message)
      return STDIN.gets.chomp
    end

    desc "import climate reports"
    task(:import_climate_reports => :environment){|t|
      overwrite_existing_data = ask("Do you want to overwrite existing data? (y/n): ")
      while !['y','n'].member?(overwrite_existing_data)
        overwrite_existing_data = ask("Please type 'y' for yes or 'n' for no. ")
      end
      if overwrite_existing_data==='y'
        ClimateReport.destroy_all
      end
      row_count = FasterCSV.open("#{Rails.root}/lib/data/climate.csv", {:headers=>true}).count
      FasterCSV.open("#{Rails.root}/lib/data/climate.csv", {:headers=>true}).each_with_index{|row,i|
        puts("importing climate report #{i+1} of #{row_count}")
        #puts(row.inspect)
        (0..11).each{|month|
          precip = row["PRECIP#{month+1}"]
          temp = row["TEMP#{month+1}"]
          unless (precip=="NA" && temp=="NA") # don't import rows with no data
            gc = GridCell.find_by_fid(row["GRIDID"])
            climate_data = {
              :month=>month, 
              #:year=>row["year"].to_i, 
            }
            climate_data.merge!({:precipitation=>row["PRECIP#{month+1}"].to_f}) unless row["PRECIP#{month+1}"]=="NA"
            climate_data.merge!({:temperature=>row["TEMP#{month+1}"].to_f}) unless row["TEMP#{month+1}"]=="NA"
            gc.climate_reports.create(climate_data)
          end
        }
=begin
        ClimateReport.create(
          :month=>row["month"].to_i, 
          :year=>row["year"].to_i, 
          :precipitation=>row["precipitation"].to_f, 
          :temperature=>row["temperature"].to_f,
          :grid_cell_id=>row["GRIDID"]
        )
=end
      }
    }

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
    }
  end
end
