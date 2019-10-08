require 'rake'
require 'erb'

desc "default is install"
task :default => :install

desc "install the dot files into user's home directory"
task :install do
  install_files
end

desc "force install"
task :force do
  install_files(true)
end

desc "install preferred ruby gems"
task :gems do
  system %Q{gem update --system}
  system %Q{gem update}

  installed_gems = `gem list --no-version`.split
  all_gems       = File.read("Resources/gems").split
  new_gems       = (all_gems - installed_gems).join(" ")
  if new_gems.empty?
    puts "No new gems to install. Exiting."
  else
    puts "Installing gems #{new_gems}"
    system %Q{gem install --no-rdoc --no-ri #{new_gems}}
  end
end

desc "remove gem doc files"
task :remove_rdoc do
  system "rm -r `gem env gemdir`/doc"
end

# ===============
# = Sub methods =
# ===============
def install_files(replace_all = false)
  replace_all ||= false
  Dir['*'].each do |file|
    next if ["Rakefile", "README.rdoc", "LICENSE", "Icon\r", "Resources", 'tmp', 'bin'].include? file

    f = File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")

    if File.exist?(f) or File.symlink?(f)
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end

  system %Q{rm -f "$HOME/bin" && ln -s "$PWD/bin" "$HOME/bin"}
end

def replace_file(file)
	puts "Replacing #{file}"
  system %Q{rm "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  source_file = File.join(__dir__, file)
  target_link = "~/.#{file}"

  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open("~/.#{file.sub('.erb', '')}", 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking #{target_link}"
    system %Q{ln -s #{source_file} #{target_link}}
  end
end
