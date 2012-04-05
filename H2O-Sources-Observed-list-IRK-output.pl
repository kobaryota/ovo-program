
#system("mkdr list-IRK.sh")
#system("/usr/bin/perl /home/ovo/OVO/program/H2O-Sources-Observed-list-IRK.pl > /home/ovo/OVO/program/list-IRK.sh");

###system("/usr/bin/perl /home/ovo/OVO/program/H2O-Sources-The-latest-Observed-list-IRK.pl > /home/ovo/OVO/list/SingleDish/H2O-Sources-The-latest-Observed-list-IRK.txt");
system("/usr/bin/perl /Users/sio/ovo/OVO/program/SingleDish-LatestObserved-H2O-IRK.pl > /Users/sio/ovo/OVO/list/SingleDish/H2O-Sources-The-latest-Observed-list-IRK.txt");
system("/usr/bin/perl /Users/sio/ovo/OVO/program/SingleDishH2O-IRK.pl");
system("cp /Users/sio/ovo/OVO/list/SingleDish/H2O-Sources-The-latest-Observed-list-IRK.txt /Volumes/sioHD/ovo/SingleDish/irk/H2O/");
system("cp /Users/sio/ovo/OVO/list/SingleDish/history/*-history.txt /Volumes/sioHD/ovo/SingleDish/history/irk/H2O/");

