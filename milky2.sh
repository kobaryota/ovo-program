#!/usr/bin/expect

expect -c "
set timeout 60 
spawn scp /home/ryota/Desktop/milky/*.txt koba@milky:/Network/Servers/milkyway.sci.kagoshima-u.ac.jp/Users/koba/Desktop/ovo/
expect \"Password:\"
send \"2003!RK\"
interact
"
