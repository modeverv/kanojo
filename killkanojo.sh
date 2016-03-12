#! /bin/bash

cd /home/seijiro/kanojo

ps aux |grep ruby |grep kanojo

kill -9 `cat pid.txt`

ps aux |grep ruby |grep kanojo

