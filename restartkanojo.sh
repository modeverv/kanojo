#! /bin/bash

cd /home/seijiro/kanojo

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

kill -9 `cat pid.txt`

bundle exec ruby kanojo.rb  >> log/kanojo.log 2>&1

ps aux |grep ruby |grep kanojo

