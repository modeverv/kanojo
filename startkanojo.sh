#! /bin/bash

cd /home/seijiro/kanojo

export PATH="$PATH:/home/seijiro/.rvm/bin" # Add RVM to PATH for scripting
/home/seijiro/.rvm/scripts/rvm
which ruby
bundle exec ruby kanojo.rb  >> /var/log/kanojo/kanojo.log 2>&1

ps aux | grep ruby

echo "kanojo is started"
