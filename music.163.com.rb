# Copyright (c) 2014 Jie Ma
# http://jma.im
# https://github.com/imjma/

require 'cgi'
require 'open-uri'
require 'json'
require 'net/http'
require 'fileutils'

class NeteaseMusic

  attr_accessor :api_song, :api_album, :headers

  def url_parser(url)
    u = URI.parse(url)
    q = CGI::parse(u.query)
    id = q['id'].first
    if url.match(/song/i)
      download_song(id)
    elsif url.match(/album/i)
      download_album(id)
    end
  end

  def call_api(uri)
    req = Net::HTTP::Get.new(uri, @headers)
    res = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }
    j = JSON.parse(res.body)
    if j['code'] == 200
      puts '  >>> ready to download'
      puts
      return j
    else
      abort ' !!! Error: %s ' % j['code']
    end
  end

  def download_song(id)
    uri = URI(self.api_song % [id, CGI::escape('['+id+']')])
    j = call_api(uri)
    song = j['songs']
    dir = File.expand_path(".")
    download(song, dir)
  end

  def download_album(id)
    uri = URI(self.api_album % id)
    j = call_api(uri)
    songs = j['album']['songs']
    a = '%s - %s' % [j['album']['artist']['name'], j['album']['name']]
    dir = File.join(File.expand_path("."), a)
    download(songs, dir)
  end

  def download(songs, dir)
    unless File.directory?(dir)
      FileUtils.mkdir_p(dir)
    end
    songs.each_with_index do |s, k|
      u = s['mp3Url']
      saved_name = '%s - %02d.%s.mp3' % [s['artists'][0]['name'], s['position'], s['name']]
      d = File.join(dir, saved_name)
      puts '  +++ downloading #%d/#%d  %s' % [k, s.length,colorize(saved_name, 1, 91)]
      puts
      if File.exist?(d)
        puts "  !!! %s already exists in %s" % [saved_name, d]
      else
        File.write(d, open(u).read, {mode: 'wb'})
        puts '### %s URL: %s -> %s' % [Time.now().strftime('%F %T'), u, d]
      end
    end
  end

  def colorize(text, color1, color2)
    "\x1b[#{color1};#{color2}m#{text}\x1b[0m"
  end

  def main(url)
    puts '  --- analysis url...... '
    puts
    u = url.gsub(/#\//, '')
    sid = url_parser(u)
    # download_song(sid)
  end

  def initialize(url)
    @api_song= 'http://music.163.com/api/song/detail?id=%s&ids=%s'
    @api_album = 'http://music.163.com/api/album/%s'
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