Mr.Scripts
======

### This is scripts I am using to make my live becomes easy

- [pp163.rb](#pp163.rb)
- [poco.rb](#poco.rb)
- [tuchong.rb](#tuchong.rb)
- [music.163.com.rb](#music.163.com.rb)


Requirements
======
```bash
$ gem install nokogiri
```


Command
======

# <a name="pp163.rb"></a>pp.163.com
```bash
$ ruby pp163.rb http://pp.163.com/kenziii/pp/11624042.html
```

It will save all photos to folder called `163_kenziii/163_kenziii_[title]`

# <a name="poco.rb"></a>poco.cn
```bash
$ ruby poco.rb -u http://photo.poco.cn/lastphoto-htx-id-3806596-p-0.xhtml [-f folder]
```

It will save all photos to folder called `poco_emarfer/poco_emarfer_[title]`
or if you give `-f folder` argu it will save all photos to folder called `folder`

# <a name="tuchong.rb"></a>tuchong.com
```bash
$ ruby tuchong.rb http://tuchong.com/244569/6161107/
```

It will save all photos to folder called `tuchong_[author id]_[author name]/tuchong_[author name]_[title]`

# <a name="music.163.com.rb"></a>music.163.com
```bash
$ ruby music.163.com.rb http://music.163.com/song?id=22781103
```

Only support single song link so far.
