# Copyright (c) 2016 Jie Ma
# http://jma.im
# https://github.com/sthtodo/

require 'nokogiri'
require 'open-uri'
require 'optparse'
require 'fileutils'

# pass argv from command
options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: %prog [options]"

  opts.on('-u', '--url URL', "Mandatory Url") do |f|
    options[:url] = f
  end
end

optparse.parse!

#Now raise an exception if we have not found a host option
raise OptionParser::MissingArgument if options[:url].nil?
# raise OptionParser::MissingArgument if options[:folder].nil?

fullUri = 'http://vegoro.lofter.com/post/' + options[:url]

# Get a Nokogiri::HTML::Document for the page we’re interested in...
doc = Nokogiri::HTML(open(fullUri))

# saved folder
folder = File.join(File.expand_path("."), 'lofter')

p "Saved folder: " + folder

FileUtils.mkdir_p(folder) unless File.directory?(folder)

# get all images url and download to local folder
doc.css('.m-detail .pic img').each do |img|
  uri = img['src'].split('?').first
  p uri
  File.write(File.join(folder, File.basename(uri)), open(uri).read, {mode: 'wb'})
end

p 'done'
