# Copyright (c) 2014 Jie Ma
# http://jma.im
# https://github.com/imjma/

require 'cgi'
require 'open-uri'
require 'json'
require 'net/http'
require 'fileutils'

class NeteaseMusic

  attr_accessor :song_api, :headers

  def url_parser(url)
    u = URI.parse(url)
    q = CGI::parse(u.query)
    return q['id'].first
  end

  def download_song(id)
    uri = URI(self.song_api % [id, CGI::escape('['+id+']')])
    req = Net::HTTP::Get.new(uri, @headers)
    res = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }
    j = JSON.parse(res.body)
    if j['code'] == 200
      puts '  >>> ready to download'
      puts
      s = j['songs'][0]
      download(s)
    else
      puts ' !!! Error: %s ' % j['code']
    end
  end

  def download(s)
    u = s['mp3Url']
    saved_name = '%s - %02d.%s.mp3' % [s['artists'][0]['name'], s['position'], s['name']]
    d = File.join(File.expand_path("."), saved_name)
    puts '  +++ downloading %s' % colorize(saved_name, 1, 91)
    puts
    if File.exist?(d)
      puts "  !!! %s already exists in %s" % [saved_name, d]
    else
      File.write(d, open(u).read, {mode: 'wb'})
      puts '### %s URL: %s -> %s' % [Time.now().strftime('%F %T'), u, d]
    end
  end

  def colorize(text, color1, color2)
    "\x1b[#{color1};#{color2}m#{text}\x1b[0m"
  end

  def main(url)
    puts '  --- analysis url...... '
    puts
    sid = url_parser(url)
    download_song(sid)
  end

  def initialize(url)
    @song_api= 'http://music.163.com/api/song/detail?id=%s&ids=%s'
    @headers = {
        "Accept" => "text/html,application/xhtml+xml,application/xml; " \
            "q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding" => "text/html",
        "Accept-Language" => "en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4,zh-TW;q=0.2",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Referer" => "http://music.163.com/",
        "User-Agent" => "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 "\
            "(KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36"
    }
    main(url)
  end

end

url = ARGV[0]
nm = NeteaseMusic.new(url)