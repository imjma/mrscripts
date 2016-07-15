# Copyright (c) 2014 Jie Ma
# http://jma.im
# https://github.com/imjma/

require 'nokogiri'
require 'open-uri'
require 'fileutils'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
url = ARGV[0]
doc = Nokogiri::HTML(open(url))

header = doc.css('.post-header-info')

title_node = header.css('h1').first

if title_node
  title = title_node.text.delete("\t").delete("\r").delete("\n").strip
else
  # get data-site-id if untitled
  title = 'untitled_' + header.css('a').first['data-site-id']
end
p "Title: " + title

author = doc.css('.post-header-info a.site-icon').first
p "Author: " + author['title'] + ' - ' + author['data-site-id']

# saved folder
folder = File.join(File.expand_path("."), 'tuchong_' + author['data-site-id'] + '_' + author['title'], 'tuchong_' + author['title'] + '_' + title)
p "Saved folder: " + folder

FileUtils.mkdir_p(folder) unless File.directory?(folder)

# get all images url and download to local folder
doc.css('.figures-wrapper figure img').each do |img|
  uri = img['src']
  p uri
  File.write(File.join(folder, File.basename(uri)), open(uri).read, {mode: 'wb'})
end

p 'done'
