#!/usr/bin/env ruby
require 'fileutils'
require 'date'
require 'exifr'

def fdate(date)
  date.strftime "%d.%m.%Y"
end


puts "Folder Dater started...\n"

Dir["19*", "20*"].select { |f| File.directory?(f) }.each do |folder|
  print "\n#{folder}: "
  date = nil
  
  if folder =~ /(\d{4}-\d{2}-\d{2})/
    date = Date.parse($1).to_time
  elsif folder =~ /(\d{4} Odds & Ends)/
    date = Time.new($1.to_i, 12, 31)
  else
    print "Finding first... "
    
    pictures = Dir.glob("#{folder}/*.jpg")
    
    if pictures.empty?
      print "No pictures in folder. Next."
      next
    end
    
    first = pictures.first

    if first && File.birthtime(first) != EXIFR::JPEG.new(first).date_time
      print "#{fdate File.birthtime(first)} > #{fdate EXIFR::JPEG.new(first).date_time} Running exif_create_date... "
      
      command = "cd \"#{folder}\" && /Users/mk/bin/exif_create_date.rb >/dev/null"
      system(command)
      print "done. "
    end
    
    date = pictures.map { |f| File.birthtime(f) }.min
  end
  
  print "#{fdate date} "
  
  if File.birthtime(folder) <= date
    print "fine."
  else
    system "SetFile -d '#{date.strftime "%m/%d/%Y %H:%M:%S"}' \"#{folder}\""
    print "set."
  end
end

puts "\nFiniss!!!"
