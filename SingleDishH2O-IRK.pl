#!/usr/bin/perl

system("rm /Users/sio/ovo/OVO/list/SingleDish/history/*-history.txt");

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
#	system("less /web/OVO/data/$b2/H2O/$b2-sort.plt > /web/OVO/list/SingleDish/$b2-newobs.txt");
	system("less /Volumes/sioHD/ovo/OVO/data/$b1/H2O/$b1-sort.plt > /Users/sio/ovo/OVO/list/SingleDish/$b1-newobs.txt");
		open(IN2," /Users/sio/ovo/OVO/list/SingleDish/$b1-newobs.txt");
        @obs = <IN2>;
        chomp @obs;
        close(IN2);
	
        foreach $obs (@obs){

		open(OUT,">>/Users/sio/ovo/OVO/list/SingleDish/history/$b1-history.txt");
		
                ($o1,$o2,$o3) = split (/\s+/, $obs);
                $sigma = $o2/$o3/2;
                $o2 =sprintf("%.2f", $o2*20);
		
		$status = "$b1 $b2 $o1 $o2";
		print OUT $status;
		#print "$b2 $b3 $o1 $o2";	
		if($sigma >= 5){		
			$sigma=sprintf("%.1f",$sigma);
			
			$yes = " Yes!($sigma)\n";
			print OUT $yes;
			#print " Yes!($sigma)";
		}else{
			$sigma=sprintf("%.1f",$sigma);
			
			$no = " No!($sigma)\n";
			print OUT $no;
			#print " No!($sigma)";
		}
		close(OUT);		
	
	}
	
	print "\n";
}
system("rm /Users/sio/ovo/OVO/list/SingleDish/*-newobs.txt");

