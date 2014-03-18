ftlopr
======

Photo Gallery sites crawler

Requirements
======
```bash
$ gem install nokogiri
```


Command
======

# pp.163.com
```bash
$ ruby pp163.rb http://pp.163.com/kenziii/pp/11624042.html
```

It will save all photos to folder called `163_kenziii/163_kenziii_[title]`

# poco.cn
```bash
$ ruby poco.rb -u http://photo.poco.cn/lastphoto-htx-id-3806596-p-0.xhtml [-f folder]
```

It will save all photos to folder called `poco_emarfer/poco_emarfer_[title]`
or if you give `-f folder` argu it will save all photos to folder called `folder`

# tuchong.com
```bash
$ ruby tuchong.rb http://tuchong.com/244569/6161107/
```

It will save all photos to folder called `tuchong_[author id]_[author name]/tuchong_[author name]_[title]`
