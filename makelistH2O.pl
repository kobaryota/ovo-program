#!/usr/bin/perl

$Ddat = "/Users/ovo/Sites/OVO/data";		## Please input a directory of data ##
$Dlist = "/Users/ovo/Sites/OVO/list";		## Please input a directory of list ##
$Dcgi = "http://milkyway.sci.kagoshima-u.ac.jp/cgi-bin/ovo";	## Please input a directory of cgi ##

print "<html>\n";
print "<head>\n";
print "<title>H2O maser Observation @ IRK</title>\n</head>\n";
print "<body>\n";
print "<h2>VERA SingleDish Observation Current Result<br>H2O maser @ IRIKI station</h2>\n";
#open(IN,"/web/OVO/list/H2OmaserList.csv");
###open(IN,"/web/OVO/list/SourceList090711.txt");##########←change this line######
open(IN,"$Dlist/SourceList.txt");
@basic = <IN>;
chomp @basic;
close(IN);

print "<table>\n";
print "<div align=right><font color=red>*</font>Detect:Yes!>=5&#963; No<5&#963;</div>\n";
print "<tr><td>name1</td><td>name2</td><td>R.A.<br>H</td><td><br>M</td><td>(J2000)<br>S</td><td>Dec.<br>D</td><td><br>M</td><td>(J2000)<br>S</td><td>Current<br>Obs. Date</td><td><br>Flux(Jy)</td><td><br>Detect(&#963;)<font color=red>*</font></td></tr>\n";
foreach $basic (@basic){
	($b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9) = split (/\s+/, $basic);
#	$b25 = $b2;
	$b25 = $b1;
	if($b25 =~ /IRAS/){
#		$b25 =~ s/\+/\\\+/;
		substr($b25, 4, 0) = " ";
	}
#	if(-s"/home/ovo/OVO/data/$b25"){
#	$b8 = $b7 * $b8;
#	print "<tr><td><a href=\"../../cgi-bin/OVO/makepage2.cgi?object=$b25\">$b2</a></td><td>$b3</td><td>$b4</td><td>$b5</td><td>$b6</td><td>$b7</td><td>$b8</td><td>$b9</td>";
###		print "<tr><td><a href=\"../../cgi-bin/OVO/makepage2.cgi?object=$b25\">$b1</a></td><td>$b2</td><td>$b3</td><td>$b4</td><td>$b5</td><td>$b6</td><td>$b7</td><td>$b8</td>";##########←change this line######
		print "<tr><td><a href=\"$Dcgi/makepage2.cgi?object=$b25\">$b1</a></td><td>$b2</td><td>$b3</td><td>$b4</td><td>$b5</td><td>$b6</td><td>$b7</td><td>$b8</td>";
#	system("tail -1 /web/OVO/data/$b2/H2O/$b2-sort.plt > $b2-newobs.txt");
###		system("tail -1 /web/OVO/data/$b1/H2O/$b1-sort.plt > $b1-newobs.txt");##########←change this line######
system("tail -1 $Ddat/$b1/H2O/$b1-sort.plt > $b1-newobs.txt");
#	open(IN2,"$b2-newobs.txt");
		open(IN2,"$b1-newobs.txt");
		@obs = <IN2>;
		chomp @obs;
		close(IN2);
		foreach $obs (@obs){
			($o1,$o2,$o3) = split (/\s+/, $obs);
			$sigma = $o2/$o3/2;
			$o2 =sprintf("%.2f", $o2*20);
			print "<td>$o1</td><td>$o2</td>";
			if($sigma >= 5){
				$sigma=sprintf("%.1f",$sigma);
				print "<td><font color=orange>Yes!</font>($sigma)</td>";
			}else{
				$sigma=sprintf("%.1f",$sigma);
				print "<td>No($sigma)</td>";
			}
		}
		print "</tr>\n";
#	}
}
print "</table>\n";
system("rm -f *newobs.txt\n");

print  "</body>\n";
print  "</html>\n";
