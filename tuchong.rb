# Copyright (c) 2014 Jie Ma
# http://jma.im
# https://github.com/imjma/

require 'nokogiri'
require 'open-uri'
require 'fileutils'

# Get a Nokogiri::HTML::Document for the page we’re interested in...
url = ARGV[0]
doc = Nokogiri::HTML(open(url))

title = doc.css('article.post header h1').first.text.delete("\t").delete("\r").delete("\n").strip
p "Title: " + title

author = doc.css('section.site-box h2 a.user-anchor').first
p "Author: " + author['title'] + ' - ' + author['data-site-id']

# saved folder
folder = File.join(File.expand_path("."), 'tuchong_' + author['data-site-id'] + '_' + author['title'], 'tuchong_' + author['title'] + '_' + title)
p "Saved folder: " + folder

FileUtils.mkdir_p(folder) unless File.directory?(folder)

# get all images url and download to local folder
doc.css('div.thread-full figure.post-photo a img').each do |img|
  uri = img['src']
  p uri
  File.write(File.join(folder, File.basename(uri)), open(uri).read, {mode: 'wb'})
end

p 'done'