#!/usr/bin/expect

expect -c "
set timeout 60 
spawn ssh koba@milky 
expect "Password:" {
send "2003!RK"
}
mkdir /Network/Servers/milkyway.sci.kagoshima-u.ac.jp/Users/koba/Desktop/aa
interact
"
