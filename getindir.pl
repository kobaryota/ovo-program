($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;
print "$year年$mon月$mday日\n";
system("mkdir /home/ryota/Desktop/ovokoba/time/$year$mon$mday");
system("mv /home/ryota/Desktop/ovokoba/time/*$year$mon*.pl /home/ryota/Desktop/ovokoba/time/$year$mon$mday");
aaa

