#!/usr/bin/ruby
require 'fileutils'

FONT_URL = 'https://github.com/abertsch/Menlo-for-Powerline/raw/master/'
FONT_PATH = File.join ENV['HOME'], 'Library', 'Fonts'
FONTS = %w{
  Menlo%20Bold%20Italic%20for%20Powerline.ttf
  Menlo%20Bold%20for%20Powerline.ttf
  Menlo%20Italic%20for%20Powerline.ttf
  Menlo%20for%20Powerline.ttf
}

GEMS = %w{bundler sinatra-reloader sqlite3}

def command?(command)
  system("which #{command} > /dev/null 2>&1")
end

def clean_name(name)
  name.gsub('%20', ' ')
end

def install_gems
  installed = `gem list`

  GEMS.each do |gem|
    install("Install gem #{gem}", installed.include?(gem), "gem install #{gem}")
  end
end

def install_fonts
  print "Install Menlo Powerline fonts."
  if File.exist? File.join(FONT_PATH, clean_name(FONTS[0]))
    puts ".. [OK]"
  else
    FONTS.each do |font|
      system("curl -s -L -O #{FONT_URL}#{font}")
      FileUtils.move font, File.join(FONT_PATH, clean_name(font))
      print '.'
    end
    puts " [DONE]"
  end
end

def install(msg, test, command)
  print msg + '... '
  
  if test
    puts "[OK]"
  else
    system(command)
    puts "[DONE]"
  end
end

#----------------------------------------
install "Own /usr/local", File.owned?('/usr/local'), "chown -R #{ENV['USER']} /usr/local"
install "Install brew", command?('brew'), '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
install "Updating & upgrading brew", false, 'brew update &>/dev/null; brew upgrade'
install "Install zsh", command?("zsh"), "brew install zsh"
install "Install oh-my-zsh", File.exist?(ENV['HOME'] + '/.oh-my-zsh'), 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
install "Install tmux", command?("tmux"), 'brew install tmux'
install "Install ruby-build", `brew list`.include?('ruby-build'), 'brew install ruby-build openssl readline'
install "Install rbenv", command?('rbenv'), 'brew install rbenv'
install "Install ruby 2.3.4", `rbenv versions`.include?('2.3.4'), 'rbenv install 2.3.4'
install "Activate ruby 2.3.4", `ruby -v`.include?('2.3.4'), "rbenv global 2.3.4"
install_gems
install_fonts
