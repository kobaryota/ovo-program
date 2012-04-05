#!/usr/bin/perl

$Ddat = "/Users/ovo/Sites/OVO/data";		## Please input a directory of data ##
$Dlist = "/Users/ovo/Sites/OVO/list";		## Please input a directory of list ##
$Dcgi = "http://milkyway.sci.kagoshima-u.ac.jp/cgi-bin/ovo";	## Please input a directory of cgi ##

print "<html>\n";
print "<head>\n";
print "<title>SiO maser Observation @ MIZ</title>\n</head>\n";
print "<body>\n";

print "<h2>VERA SingleDish Observation Current Result<br>SiO maser @ MIZUSAWA station</h2>\n";
open(IN,"$Dlist/SiOmaserList.csv");
@basic = <IN>;
chomp @basic;
close(IN);
print "<table>\n";
print "<div align=right><font color=red>*</font>Detect:Yes!>=5&#963; No<5&#963;</div>\n";
print "<tr><td>name1</td><td>name2</td><td>R.A.<br>H</td><td><br>M</td><td>(J2000)<br>S</td><td>Dec.<br>D</td><td><br>M</td><td>(J2000)<br>S</td><td>Current<br>Obs. Date</td><td><br>Flux(Jy)v1/<br>Detect(&#963;)<font color=red>*</font></td><td><br>v2/<br>Detect(&#963;)<font color=red>*</font></td></tr>\n";
foreach $basic (@basic){
	($b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9) = split (/\s+/, $basic);
	$b25 = $b2;
	if($b25 =~ /IRAS/){
#		$b25 =~ s/\+/\\\+/;
		substr($b25, 4, 0) = " ";
	}
#	$b8 = $b7 * $b8;
	print "<tr><td><a href=\"$Dcgi/makepage2.cgi?object=$b25\">$b2</a></td><td>$b3</td><td>$b4</td><td>$b5</td><td>$b6</td><td>$b7</td><td>$b8</td><td>$b9</td>";
	system("tail -1 $Ddat/$b2/SiO/v1/$b2-sortv1.plt > $b2-newobs.txt");
	open(IN1,"$b2-newobs.txt");
	@obs1 = <IN1>;
	chomp @obs1;
	close(IN1);
	foreach $obs1 (@obs1){
		($o1,$o2,$o3) = split (/\s+/, $obs1);
		$sigma = $o2/$o3/2;
		$o2 =sprintf("%.2f", $o2*24.42);
		if($sigma >= 4){
			$sigma = sprintf("%.1f",$sigma);
			print "<td>$o1</td><td>$o2 / <font color=orange>Yes!</font>($sigma)</td>";
		}else{
			$sigma = sprintf("%.1f",$sigma);
			print "<td>$o1</td><td>$o2 / No($sigma)</td>";
		}
	}
	system("tail -1 $Ddat/$b2/SiO/v2/$b2-sortv2.plt > $b2-newobs.txt");
	open(IN2,"$b2-newobs.txt");
	@obs2 = <IN2>;
	chomp @obs2;
	close(IN2);
	foreach $obs2 (@obs2){
		($o1,$o2,$o3) = split (/\s+/, $obs2);
		$sigma = $o2/$o3/2;
		$o2 =sprintf("%.2f", $o2*24.42);
		if($sigma >= 4){
			$sigma = sprintf("%.1f",$sigma);
			print "<td>$o2 / <font color=orange>Yes!</font>($sigma)</td>";
		}else{
			$sigma = sprintf("%.1f",$sigma);
			print "<td>$o2 / No($sigma)</td>";
		}
	}
	print "</tr>\n";
}
print "</table>\n";
system("rm *newobs.txt\n");

print  "</body>\n";
print  "</html>\n";
