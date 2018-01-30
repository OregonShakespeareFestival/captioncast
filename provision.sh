# install ruby
sudo yum update -y
sudo yum install -y ruby ruby-devel redis libxml2-devel libxslt-devel mysql-devel sqlite-devel openssl-devel @development
sudo yum install -y vim

sudo gem update --system
echo "gem: --no-document" > ~/.gemrc

# install bundler
gem install bundler

# install javascript runtime
sudo yum install -y epel-release nodejs

# start redis
sudo systemctl enable redis
sudo systemctl start redis