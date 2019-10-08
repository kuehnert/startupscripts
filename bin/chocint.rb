#!/usr/bin/env ruby
require 'zip'
require 'net/http'
require 'uri'
require 'slop'
require 'open-uri'
require 'progressbar'
require 'down'

VERSION = "0.1"
URL = "https://chocolatey.org/api/v2/package"
MEGABYTE = 1024 ** 2;

def download_no_redirect(uri, filename)
  counter = 0

  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    request = Net::HTTP::Get.new(uri)

    http.request request do |response|
      pbar = ProgressBar.create(title: filename, total: response['content-length'].to_i)

      open filename, 'w' do |io|
        response.read_body do |chunk|
          io.write chunk
          counter += chunk.length
          pbar.total = counter
        end
      end

      pbar.finish
    end
  end
end

def download_file(uri, filename, limit = 10)
  raise ArgumentError, 'too many HTTP redirects' if limit == 0
  response = Net::HTTP.get_response( URI(uri) )

  case response
  when Net::HTTPSuccess then
    download_no_redirect(uri, filename)
  when Net::HTTPRedirection then
    location = response['location']
    # warn "redirected to #{location}"
    download_file(URI(location), filename, limit - 1)
  else
    warn "Unknown condition: #{response.value}"
  end
end

def download_file2(uri, filename)
  open(uri) do |data|
    pbar = ProgressBar.create(title: filename, total: 100.to_i)

    open filename, 'w' do |io|
      until data.eof?
        chunk = data.read(1024*1024)
        io.write chunk
        pbar.increment
      end
      # data.each_chunk(1024*1024) do |chunk|
      #   io.write chunk
      #   # counter += chunk.length
      #   # pbar.total = counter
      #   pbar.increment
      # end
    end

    pbar.finish
  end
end

def download_file3(uri, filename)
  pbar = ProgressBar.create(title: filename, total: nil)
  Down.download(uri, destination: filename,
    content_length_proc: -> (content_length) { pbar.total = content_length },
    progress_proc:       -> (progress)       { pbar.progress = progress }
  )
end

# Excerpt from https://github.com/leejarvis/slop
options = Slop.parse do |o|
  o.string '-p', '--package', 'name of a package', required: true
  o.bool '-v', '--verbose', 'enable verbose mode'
  o.bool '-q', '--quiet', 'suppress output (quiet mode)'
  o.on '--version', 'print the version' do
    puts VERSION
    exit
  end
end

package = options[:package]
packagezip = package + '.zip'
puts "Internalising package #{package}..."

uri = URI.parse( File.join(URL, package) )
puts "1. Downloading #{uri} to #{packagezip}"
download_file3(uri, packagezip)


puts "2. Unzipping file"
Zip::File.open(packagezip) do |zip_file|
  names = zip_file.select(&:file?).map(&:name)
  names.reject! { |n| n=~ /\_rels|\[Content\_Types\].xml|package/ }
  names.each do |name|
    puts name
    dest = File.join("./#{package}/", name)
    FileUtils.mkdir_p( File.dirname(dest) )
    zip_file.extract(name, dest) { true }
  end
end

puts "3. Downloading referenced urls"
install_script = File.read( File.join(package, 'tools', 'chocolateyInstall.ps1' ) )
urls = install_script.scan(/https?:\/\/[^\s']+/)

urls.each do |url|
  puts "Downloading #{url}"
  fname = File.join( package, 'tools', File.basename( url ) )

  unless File.exist? fname
    download_file3(url, fname)
  end
end

puts "Finiss!"
