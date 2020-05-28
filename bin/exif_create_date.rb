#!/usr/bin/env ruby
require 'date'
require 'exifr'

photos   = Dir.glob('*.???')
taken_at = Date.today

photos.each do |photo|
  print "#{photo}: "

  # check consistency
  if photo =~ /.jpe?g/
    result = `/usr/local/bin/jpeginfo -c "#{photo}"`
    unless result =~ /OK/
      print "CORRUPT " 
      break
    end

    taken_at = EXIFR::JPEG.new(photo).date_time
  end

  system "SetFile -d '#{taken_at.strftime "%m/%d/%Y %H:%M:%S"}' \"#{photo}\""
  
  puts "OK."
end

puts "Finniss!!! #{photos.size} Files inspected."
