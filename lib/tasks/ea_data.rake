namespace :earthaudit do
  namespace :data do

    def ask(message)
      print(message)
      return STDIN.gets.chomp
    end

    desc "import plantings"
    task(:import_plantings=> :environment){|t|
      overwrite_existing_data = ask("Do you want to overwrite existing data? (y/n): ")
      while !['y','n'].member?(overwrite_existing_data)
        overwrite_existing_data = ask("Please type 'y' for yes or 'n' for no. ")
      end
      if overwrite_existing_data==='y'
        Planting.destroy_all
      end
      row_count = FasterCSV.open("#{Rails.root}/lib/data/plantings.csv", {:headers=>true}).count
      FasterCSV.open("#{Rails.root}/lib/data/plantings.csv", {:headers=>true}).each_with_index{|row,i|
        puts("importing planting #{i+1} of #{row_count}")
        gc = GridCell.find_by_fid(row["FID"])
        crop_name = row["Crop"].downcase
        the_crop = Crop.find_or_create_by_name(crop_name)
        the_dates = {:planting_start=>row["Pst"], :planting_end=>row["Pen"], :harvest_start=>row["Hst"], :harvest_end=>row["Hen"]}
        the_dates.each{|k,v| the_dates[k] = (v=="NA" ? nil : Date.new(2010, v.split('.').first.to_i, 1))}
=begin
        p_start = Date.new(2010, row["Pst"].split('.').first, 1)
        p_end = Date.new(2010, row["Pen"].split('.').first, 1)
        h_start = (row["Hst"]=="NA" ? nil : Date.new(2010, row["Hst"].split('.').first, 1))
        h_start = (row["Hst"]=="NA" ? nil : Date.new(2010, row["Hst"].split('.').first, 1))
        h_end = Date.new(2010, row["Pen"].split('.').first, 1)
=end
        the_planting = the_dates.merge!({:crop=>the_crop})
        gc.plantings.create(the_planting)
        #Planting(id: integer, grid_cell_id: integer, crop_id: integer, planting_start: datetime, planting_end: datetime, harvest_start: datetime, harvest_end: datetime, created_at: datetime, updated_at: datetime)

        #puts(row.inspect)
=begin
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
=end
      }
    }

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
