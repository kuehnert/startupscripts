puts "Loading .irbrc for #{RUBY_DESCRIPTION} ..."

IRB.conf[:PROMPT_MODE]  = :SIMPLE

require 'irb/ext/save-history'
require 'irb/completion'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.#{File.basename($0)}_history"

require 'yaml'
require 'ap'
# require 'looksee' # lp <object>
# require 'clipboard'

# ================
# = Copy & Paste =
# ================
# def copy(str)
#   Clipboard.copy(str)
# end

# def copy_history
#   history = Readline::HISTORY.entries
#   index = history.rindex("exit") || -1
#   content = history[(index+1)..-2].join("\n")
#   puts content
#   copy content
# end

# def paste
#   Clipboard.paste
# end

class Object
  # list methods which aren't in superclass
  # (obj.methods - obj.class.superclass.instance_methods).sort
  def local_methods(obj = self)
    (obj.methods - Object.instance_methods).sort
  end

  # print documentation: ri 'Array#pop', Array.ri, Array.ri :pop, arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    puts `ri '#{method}'`
  end
end

puts "Hier passiert was!"
load '~/.railsrc' if defined?(Rails)
