#!/usr/bin/perl

###open(IN,"/web/OVO/list/H2OmaserList.csv");
open(IN,"/Users/sio/ovo/OVO/list/SourceList090711.txt");
@basic = <IN>;
chomp @basic;
close(IN);

print "name1 name2 Obs.Date Flux(Jy) Detect(&#963;)\n";
	

foreach $basic (@basic){
        ($b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9) = split (/\s+/, $basic);
#	$b25 = $b2;
	$b25 = $b1;
	if($b25 =~ /IRAS/){
#		$b25 =~ s/\+/\\\+/;
		substr($b25, 4, 0) = " ";
	}
#	system("tail -1 /web/OVO/data/$b2/H2O/$b2-sort.plt > $b2-newobs.txt");
###		system("tail -1 /web/OVO/data/$b1/H2O/$b1-sort.plt > $b1-newobs.txt");##########←change this line######
system("tail -1 /Volumes/sioHD/ovo/OVO/data/$b1/H2O/$b1-sort.plt > $b1-newobs.txt");
#	open(IN2,"$b2-newobs.txt");
		open(IN2,"$b1-newobs.txt");
        @obs = <IN2>;
        chomp @obs;
        close(IN2);
	
        foreach $obs (@obs){
                ($o1,$o2,$o3) = split (/\s+/, $obs);
                $sigma = $o2/$o3/2;
                $o2 =sprintf("%.2f", $o2*20);
		print "$b1 $b2 $o1 $o2";	
		if($sigma >= 5){		
			$sigma=sprintf("%.1f",$sigma);
			print " Yes!($sigma)";
		}else{
			$sigma=sprintf("%.1f",$sigma);
			print " No!($sigma)";
		}
				
	
	}
	
	print "\n";
}
system("rm *newobs.txt\n");


