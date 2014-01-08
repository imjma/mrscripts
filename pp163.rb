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
p title

authorid = url.match(/163.com\/(.+)\/pp/)[1]
p authorid

folder = File.join(File.dirname(__FILE__), '163_' + authorid , '163_' + authorid + '_' + title)
p folder

FileUtils::mkdir_p folder

doc.css('div.pic-area img.z-tag').each do |img|
  uri = img['data-lazyload-src']
  p uri
  File.open(File.join(folder, File.basename(uri)), 'wb') { |f| f.write(open(uri).read)}
end

p 'done'