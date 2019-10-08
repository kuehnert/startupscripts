#!/usr/bin/env ruby -wKU
require "date"
require "fileutils"

PATH = File.join( ENV['HOME'], 'Documents', 'GITProjects')
Dir.chdir PATH

# ================
# = Setup values =
# ================
git = `which git`.chomp
if git.empty?
  puts "Error: git not found. Exiting."
  exit 1
end

YEAR = Date.today.year

begin
  print "Stufe? "
  stufe = gets.to_i
end while stufe < 5 || stufe > 13

print "Block? "
block = gets.to_i

print "Fach (Informatik)? "
subject = gets.chomp
subject = "Informatik" if subject.empty?

block_str = "#{stufe}-GK#{"-G#{block}" if block > 0}"
folder = [YEAR, block_str, subject].join('-')

print "Really create repository #{folder}? (y/N) "
unless gets.chomp.downcase == "y"
  puts "Aborting."
  exit 
end

# ===============
# = Do the work =
# ===============
print "\nInitialising git repository... "
`#{git} init #{folder}`

Dir.chdir 'InternGitosis'
`#{git} pull`
unless $?.success?
  puts "Error: Problem pulling Gitosis"
  exit 1
end
puts "done."


print "Adding repo to gitosis... "
repo_string = <<EOS

[repo #{folder}]
daemon = yes
description = #{YEAR}-#{YEAR-2000+1} Stufe #{block_str} #{subject} Unterrichtsprojekte
owner = M. Kühnert
EOS
config = File.read "gitosis.conf"
config.sub!(/(\[group mkpublic\]\nwritable =)/, "\\1 #{folder}")
config << repo_string
File.open("gitosis.conf", "w") { |io| io.write config }

`#{git} commit -a -m "Added #{folder}" 2>&1`
unless $?.success?
  puts "Error: Problem commiting changes to gitosis"
  exit 1
end

`#{git} push 2>&1`
puts "done."


print "Adding origin master to repository #{folder}... "
Dir.chdir File.join(PATH, folder)
`#{git} remote add origin git@intern.marienschule.com:#{folder}.git`
unless $?.success?
  puts "Error: Problem adding origin to #{folder}"
  exit 1
end
puts "done."


print "Pushing initial dummy commit... "
File.open("dummy.txt", "w") { |io| io.puts "Here Be Dragons" }
`#{git} add dummy.txt`
`#{git} commit -m "Initial dummy commit"`
unless $?.success?
  puts "Error: Problem commiting changes to #{folder}"
  exit 1
end
`#{git} push origin master 2>&1`
unless $?.success?
  puts "Error: Problem pushing changes to gitosis"
  exit 1
end
puts "done."

print "Setting world readable permission for new repository... You may be prompted for your password. "
`ssh -t mk@intern sudo chmod o+rx /Users/git/repositories/#{folder}.git 2>&1`
unless $?.success?
  puts "Error: Setting permissions on /Users/git/repositories/#{folder}.git!"
  exit 1
end
puts "done."

puts "Script finished successfully. Exiting."
