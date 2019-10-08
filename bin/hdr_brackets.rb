#!/usr/bin/env ruby
require 'fileutils'

puts "HDR Bracket Sorter started...\n\n"

# Create Sub folders
@series               = []
@delta                = nil
@photos_import_folder = File.basename(Dir.pwd)
@hdr_brackets_folder  = "#{@photos_import_folder} HDR"
@output               = ''
Dir.mkdir(@photos_import_folder) unless File.exist?(@photos_import_folder)
Dir.mkdir(@hdr_brackets_folder) unless File.exist?(@hdr_brackets_folder)

def move_series
  @output = "--- Series finished. Moving #{@series.size} photos to HDR folder.\n" + @output
  # @series stopped
  # copy first picture to Import folder
  first_file = @series.first[:file]
  `exiftool -keywords+="HDR Bracket" -o "#{File.join(@photos_import_folder, first_file)}" #{first_file} &> /dev/null`
  # FileUtils.cp @series.first[:file], @photos_import_folder, preserve: true
  
  # move each @series picture to HDR folder
  @series.each { |photo| FileUtils.mv photo[:file], @hdr_brackets_folder }
  
  # Reset @series
  @series = []
  @delta = nil
end

Dir.glob('*.ARW') do |file|
  @output = "File " + file + "... "
  exposure_mode = `exiftool -ReleaseMode #{file}`[/(?<=:\s).+$/]
  
  if exposure_mode == "Exposure Bracketing"
    exposure = `exiftool -ExposureCompensation #{file}`[/(?<=:\s).+$/].to_f
    @output << "exposure #{exposure}, "
    
    if @series.empty?
      # Neue Serie, speichere Bild ein
      @series << { file: file, exposure: exposure }
      @output = "--- New series\n" + @output + "First in series"
    elsif @series.size == 1
      # Ein Bild drin, bestimme @delta und speichere Bild ein
      # Annahme: Exposure von Bild 2 < exposure von Bild 1
      @delta = (@series.first[:exposure] - exposure).abs.round(1)
      
      if @delta == 0.0 or @delta >= 3
        # etwas stimmt nicht
        puts "\nFEHLER: Etwas stimmt nicht. Bitte Dateien von Hand sortieren. Breche ab."
        exit 1
      end
      
      @output << "Added to series, delta: #{@delta}"
      @series << { file: file, exposure: exposure }
    else
      # Mehrere Bilder bereits enthalten
      next_exposure = @series.first[:exposure] + (-1) ** @series.size * @series.size / 2 * @delta
      if next_exposure == exposure 
        # is @series bracket
        @series << { file: file, exposure: exposure }
        @output << "Added to series"
      else
        @output = "--- New series\n" + @output

        move_series

        @series << { file: file, exposure: exposure } 
      end
    end
  else
    move_series unless @series.empty?
    
    # move file to Photos Import Folder
    FileUtils.mv file, @photos_import_folder
    @output << "No bracket, moved to Import Folder"
  end
  
  puts @output
  @output = ''
end

# Move series if not empty
move_series unless @series.empty?

@output << "\nFiniss!!!"
puts @output
