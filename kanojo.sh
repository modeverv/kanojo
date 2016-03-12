#! /bin/bash

cd /home/seijiro/kanojo

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

bundle exec ruby kanojo.rb  >> log/kanojo.log 2>&1


