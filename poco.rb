# Copyright (c) 2014 Jie Ma
# http://jma.im
# https://github.com/imjma/

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
  opts.on('-f', '--folder FOLDER', "Option saved folder") do |f|
    options[:folder] = f
  end
end

optparse.parse!

#Now raise an exception if we have not found a host option
raise OptionParser::MissingArgument if options[:url].nil?
# raise OptionParser::MissingArgument if options[:folder].nil?

# Get a Nokogiri::HTML::Document for the page we’re interested in...
doc = Nokogiri::HTML(open(options[:url]))

# saved folder
if options[:folder].nil?
  prefix = 'poco'
  title = doc.css('div#user_intro h3.Title').first.content
  author = doc.css('span.page-copyright a').first.content
  author_url = doc.css('span.page-copyright a').first.text
  folder = File.join(File.expand_path("."), prefix + '_' + author, prefix + '_' + author + '_' + title)

  p "Title: " + title
  p "Author: " + author
else
  folder = File.join(File.expand_path("."), options[:folder])
end

p "Saved folder: " + folder

FileUtils.mkdir_p(folder) unless File.directory?(folder)

# get all images url and download to local folder
doc.xpath('//img[@data_org_bimg]/@data_org_bimg').each do |img|
  uri = img.value.split('?').first
  p uri
  File.write(File.join(folder, File.basename(uri)), open(uri).read, {mode: 'wb'})
end

p 'done'
