##About this Project
--------------------

In support of making theatre accessible to a broader audience we seek to build the worlds best, free, open/closed caption system. Theatres around the world are implementing open caption on proprietary expensive systems that don't give their audience the very best augmented experience.

This projects goal is simple : Provide a free GPLv3 based open caption software suite that utilizes industry standards. The project will use Ruby on Rails, Responsive Web Design, and Gems like the Chromecast gem to output to as many platforms as possible giving the consumer a choice of how they would like to view the captions.

---

##Pivotal Tracker Project
-------------------------

https://www.pivotaltracker.com/n/projects/1184042

##Caption Cast Rails
--------------------

An open source multilingual open caption project.  Inspired by [captioncast](https://bitbucket.org/andrewkr/captioncast) authored by [Andrew Krug](https://bitbucket.org/andrewkr)

###Development Tools:
---------

`sudo yum install -y ruby ruby-devel rubygems redis libxml2-devel libxslt-devel sqlite3-devel openssl-devel @development`  
`gem install rails`  
`bundle`  
`rake db:migrate`
`rake db:seed`
`systemctl enable redis`
`systemctl start redis`
`rails s`

In another terminal run: `rake resque:work QUEUE='*'`
Load the resque schedule `rake resque:setup_schdule`
Finally run the resque task scheduler `rake resque:scheduler`

A vagrant file is also provided in the project for use.  

##Docker Support:
-----------------

This project now supports running on Docker Containers. You'll find the "Dockerfile in the root of the project."

Docker image is published here for consumption:

[DockerHub](https://registry.hub.docker.com/u/andrewkrug/captioncast/)

###Resources:
-------------

-	[Nokogiri Docs](http://www.nokogiri.org/tutorials/)

###Contributors
---------------

-	[Andrew Krug](https://bitbucket.org/andrewkr)
-	[Joel Ferrier](https://bitbucket.org/joel-ferrier)
-	[Randolph Jones](https://github.com/randolphjones)
-	[Tony Hess](https://github.com/toeknee919)
-	[Amanda Denbeck](https://github.com/denbecka)
