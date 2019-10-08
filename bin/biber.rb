#!/usr/bin/env ruby
require 'csv'
require 'yaml'

filename = ARGV[0]

unless filename && File.exist?(filename)
  puts "FEHLER: Keine Datei angegeben. Beende."
  exit 1
end

print "Zug oder Kurs (zB '7b' oder '10G11')? "
kurs  = $stdin.gets.chomp
stufe = kurs.to_i

output_filename = "Biber#{kurs}_Output.csv"
puts "Reading from #{output_filename}..."

namen = CSV.read(filename, headers: true)

output = namen.map do |student|
  login = "mso#{stufe}#{student['Nachname']}#{student['Vorname'][0]}"
  login = login.downcase.gsub("ö",'oe').gsub('ä','ae').gsub('ü', 'ue').gsub('ß', 'ss')

  pw = student['Vorname'].reverse.downcase + (student['Nachname'][0].ord - "A".ord + 1).to_s
  pw = pw.gsub("ö",'oe').gsub('ä','ae').gsub('ü', 'ue').gsub('ß', 'ss')

  sex = student['Geschlecht'] # == 'm' ? 'male' : 'female'

  "#{kurs},#{stufe},#{student['Vorname']},#{student['Nachname']},#{login},#{pw},#{sex}"
end

puts "Ausgabe:"
puts output
File.open(output_filename, "w") { |io|  io.puts output.join("\n") }
`open #{output_filename}`
puts "Fertig."
