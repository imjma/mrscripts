ftlopr
======

Photo Gallery sites crawler

Requirements
======
```bash
$ gem install nokogiri
```

# pp.163.com
```bash
$ ruby pp163.rb http://pp.163.com/kenziii/pp/11624042.html
```

It will save all photos to folder called `163_kenziii/163_kenziii_[title]`

# poco.cn
```bash
$ ruby poco.rb -u http://my.poco.cn/lastphoto_v2-htx-id-3806596-user_id-64663251-p-0.xhtml [-f folder]
```

It will save all photos to folder called `poco_emarfer/poco_emarfer_[title]`
or if you give `-f folder` argu it will save all photos to folder called `folder`