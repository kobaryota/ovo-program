@youbi = ('日', '月', '火', '水', '木', '金', '土');
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;
print "$year年$mon月$mday日($youbi[$wday]) $hour時$min分$sec秒\n";
