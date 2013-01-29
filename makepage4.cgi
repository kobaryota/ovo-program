#!/usr/bin/perl
##^[$B:BI88!:w^[(B
##^[$BI=<($9$k$N$O!"$"$kN%3Q0JFb$NE7BN0lMw^[(B
#^[$BE7BN>pJs$H%9%Z%/%H%k!&%i%$%H%+!<%V$N=L>.HG^[(B
##last update 2009/01/05

#^[$B1_<~N($rDj5A^[(B
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ); }
$pai = atan2(1.0,1.0)*4;

print "Content-type: text/html; charset=euc-jp";
print "Content-type: image/png\n\n";

print  "<html>\n";
print  "<head>\n";
print  "<title>Query by Coodirate</title></head>\n";
print  "<body>\n";
#form^[$B$+$i$N^[(Bvalue^[$B$r^[(B$QbC^[$B$K3JG<^[(B
use CGI qw(param);
$QbC = param('QbC');
$insep = param('insep');
#^[$BF~NO$5$l$?:BI8$r%i%8%"%s$KJQ49^[(B
($RAh,$RAm,$RAs,$Decd,$Decm,$Decs) = split (/\s/, $QbC);
$RA = ($RAh + $RAm/60 + $RAs/3600) * $pai/12;
if($Decd >= 0){
        $Dec = ($Decd + $Decm/60 + $Decs/3600) * $pai/180;
}else{
        $Decd = -1*$Decd;
        $Dec = ($Decd + $Decm/60 + $Decs/3600) * $pai/180;
        $Dec = -1*$Dec;
}
while ($RA < 0 or $RA > 2*$pai or $Dec < -$pai/2 or $Dec > $pai/2){
        print "<p>It is improper value.<br>\n";
        print "Please input again.</p>\n";
}
print "Your Query is $QbC.<br>\n";
print "Hits as follows in $insep [deg].<br>\n";
print "<table>\n";
print "<tr><td>Separation<br>[deg]</td><td>Name1</td><td>Name2</td><td>R.A.<br>hh</td><td valign=bottom>mm</td><td>(J2000)<br>ss</td><td>Dec.<br>dd</td><td valign=bottom>mm</td><td>(J2000)<br>ss</td></tr>\n";

#^[$B%j%9%H$N:BI8$r%i%8%"%s$KJQ49$7!"F~NOCM$HHf3S^[(B
#1^[$B!k0JFb$NE7BN$r%j%9%H%"%C%W^[(B
$no = 0;
open(IN,"/home/ryota/Desktop/OVO-AUTO/HTML/list/SourceList.txt");
@line = <IN>;
chomp @line;
close(IN);
foreach $line (@line){
        #($no,$name1,$name2,$rh,$rm,$rs,$sin,$dd,$dm,$ds,$epoch,$vlsr) = split (/\s/, $line);
        ($name1,$name2,$rh,$rm,$rs,$dd,$dm,$ds,$vlsr) = split (/\s/, $line);
        #if($epoch eq 2000){
        #print "$line\n";
        $ra = ($rh + $rm/60 + $rs/3600) * $pai/12;
        if($dd>=0){
                $dec = ($dd + $dm/60 + $ds/3600) * $pai/180;
        }else{
                $dd = -1*$dd;
                $dec = ($dd + $dm/60 + $ds/3600) * $pai/180;
                $dec = -1*$dec;
        }
        $d = sin($Dec)*sin($dec)+cos($Dec)*cos($dec)*cos($RA-$ra);
        $sep = &acos($d);
        $radi = $insep*$pai/180;
        #if($sep < $pai/4920){
        if($sep < $radi){
                #print "$sep<br>";
                $sep = sprintf("%.4f",$sep*180/$pai);
                $sdd = $sin * $dd;
                print "<tr><td>$sep</td><td>";
                $object = $name1;
                if($object =~ /IRAS/){
                        $object =~ s/IRAS/IRAS /g;
                }
                print "<a href=\"../../cgi-bin/makepage2.cgi?object=$object\">$name1</a></td>";
                print "<td>$name2</td><td>$rh</td><td>$rm</td><td>$rs</td><td>$sdd</td><td>$dm</td><td>$ds";
                print "</td></tr>\n";
                ++$no;
        }
        #}
}
if($no eq 0){
        print "There is no hit in OVO for your query.<br>\n";
}
print  "</body>\n";
print  "</html>\n";


