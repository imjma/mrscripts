# Copyright (c) 2014 Jie Ma
# http://jma.im
# https://github.com/imjma/

require 'nokogiri'
require 'open-uri'
require 'fileutils'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
url = ARGV[0]
doc = Nokogiri::HTML(open(url))

title = doc.css('h2#p_username_copy').first.text.delete("\t").delete("\r").delete("\n").strip
p "Title: " + title

authorid = url.match(/163.com\/(.+)\/pp/)[1]
p "Author: " + authorid

# saved folder
folder = File.join(File.expand_path("."), '163_' + authorid , '163_' + authorid + '_' + title)
p "Saved folder: " + folder

FileUtils.mkdir_p(folder) unless File.directory?(folder)

# get all images url and download to local folder
doc.css('div.pic-area img.z-tag').each do |img|
  uri = img['data-lazyload-src']
  p uri
  File.write(File.join(folder, File.basename(uri)), open(uri).read, {mode: 'wb'})
end

p 'done'