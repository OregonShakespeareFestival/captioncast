##About this Project
---
In support of making theatre accessible to a broader audience we seek to build the worlds best, free, open/closed caption system.  Theatres around the world are implementing open caption on proprietary expensive systems that don't give their audience the very best augmented experience.

![currentboard](readme-static/01night-blogSpan.jpg)



##Caption Cast Rails
---
A rails implementation of [captioncast](https://bitbucket.org/andrewkr/captioncast) authored by [Andrew Krug](https://bitbucket.org/andrewkr)

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

####Currently Broken
Generate a certificat for TLS connection:
`rake setup:certificate`

###Resources:
---

- [Nokogiri Docs](http://www.nokogiri.org/tutorials/)
- [Chromecast Gem](https://rubygems.org/gems/chromecast)
- [Chromecast Gem Documentation](http://rubydoc.info/gems/chromecast/1.0/frames)

###Contributors
---

- [Andrew Krug](https://bitbucket.org/andrewkr)
- [Joel Ferrier](https://bitbucket.org/joel-ferrier)
