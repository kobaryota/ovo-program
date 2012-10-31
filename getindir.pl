($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;
print "$year年$mon月$mday日\n";
system("mkdir /Users/koba/Desktop/$year$mon$mday");
system("mv /Users/koba/Desktop/*$year$mon*.txt /Users/koba/Desktop/$year$mon$mday");

