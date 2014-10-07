##Caption Cast Rails
---
A rails implementation of captioncast

###Environment Preparation:
---

Add `gem: --no-document` to `~/.gemrc`

###Tools:
---

`sudo yum install -y ruby ruby-devel rubygems libxml2-devel libxslt-devel sqlite3-devel openssl-devel @development`  
`gem install rails`  
`bundle`  

###Chromecast Prep:
---

Generate a certificat for TLS connection:  
`rake setup:certificate`

###Resources:
---

[Chromecast Gem](https://rubygems.org/gems/chromecast)
[Chromecast Gem Documentation](http://rubydoc.info/gems/chromecast/1.0/frames)
