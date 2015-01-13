#!/bin/bash
cd /rails
bundle exec unicorn -D -p 8080
nginx
