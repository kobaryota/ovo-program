#!/usr/local/bin/perl
##^[$BE7BNL>8!:w$+$i3FE7BN$N%Z!<%8$rI=<($9$k!#^[(B
##^[$BI=<($9$k$N$O!"E7BN>pJs$H%9%Z%/%H%k!&%i%$%H%+!<%V$N=L>.HG^[(B
##last update 2009/09/15 by S.Shiozaki

$data = "/home/ryota/Desktop/OVO-AUTO/HTML/data";    ##Please input a directry of maser source data##
$address = "http://localhost/data";       ##Please input a address of maser source data##
$list = "/home/ryota/Desktop/OVO-AUTO/list";    ##Please input a directry of list##

print "Content-type: text/html; charset=euc-jp";
print "Content-type: image/png\n\n";

print  "<html>\n";
print  "<head>\n";
print  "<title>objest infomation</title></head>\n";
print  "<body>\n";
#form^[$B$+$i$N^[(Bvalue^[$B$r^[(B$object^[$B$K3JG<^[(B
use CGI qw(param);
$object = param('object');
#chomp $object;
#$object^[$B$K2?$bF~NO$5$l$J$+$C$?$i!"%W%m%0%i%`$r;_$a$k^[(B
#if($object <= 0){exit(0)}
#$object^[$B$H0lCW$9$kE7BN$,$"$C$?$i!"E7BNL>I=<(!"^[(BSourceList^[$B$X^[(B
$no = 0;
$object =~ s/\+/\\\+/g;
print "<table>\n";
###open(IN,"/web/OVO/list/NameList.txt");
open(IN,"$list/NameList.txt");
while ($line = <IN>) {
        chomp $line;
        if($line =~ / $object,/i){
                ($checkname) = split (/\s+/, $line);
                #print "checkname is $checkname\n";
                $object =~ s/\\//g;
                print  "<p><h2>profile of $object</h2>\n";
                print  "</p>\n";
                $line =~ s/(?:.+\s\s)//g;
#               print "<p>object name : $line\n</p>";
                @name = split (/,/, $line);
#               $i = 0;
                print "<tr><td valign=top>Identifier : </td><td>\n";
                print "<table>\n";
                for($i=0;$i<=$#name;$i+=4){
                        print "<tr><td>$name[$i] </td>\n";
                        print "<td>$name[$i+1] </td>\n";
                        print "<td>$name[$i+2] </td>\n";
                        print "<td>$name[$i+3]</td></tr>\n";
                }
                print "</table>\n";
                print "</td></tr>\n";
                ++$no;
        }
}
#$object^[$B$H0lCW$9$kE7BN$,$J$+$C$?$i!"0J2<$NCm0UJ8$rI=<(!"%W%m%0%i%`=*N;^[(B
#^[$B1~5^=hCV$G!"I=<(?t^[(Bup?
if($no eq 0){
        $object =~ s/\\//g;
        $object =~ s/ //g;
        $checkname = $object;
        print  "<p><h2>profile of $object</h2>\n";
        print "<tr><td valign=top>Identifier : </td><td>\n";
        print "$checkname</td></tr>\n";
        #print "<p>Identifier not found in this database : $object</p>\n";
        #print "<p>When you use this database, please attend to following items.<br><br>\n";
        #print "Case of retrieving identifier :<br>\n<ul>\n";
        #print "<li>Use a space bitween 'IRAS,IRC' and following numbers.</li>\n";
        #print "[IRAS00050-2546] &#8594; [IRAS 00050-2546]<br>\n";
        #print "<li>Don't use hyphen'-' as a space for GCVS name.</li>\n";
        #print "[TY-Cas] &#8594; [TY Cas]<br>\n</ul>\n";
        #print "Case of retrieving coordinate :<br>\n";
        #print "<ul>\n<li>Wait a moment.</li>\n</ul>\n</p>";
        #exit(0);
}

#$checkname =~ s/(?:+\d)/\+\d/g;
#print "checkname is $checkname<br>\n";
$checkname =~ s/\+/\\\+/g;
#SourceList^[$B$+$i:BI8!"B.EY!"6/EY$rI=<(^[(B
#open(IN, "../../OVO/list/SourceList2.txt");
###open(IN, "../../OVO/list/SourceList.txt");
open(IN, "$list/sort-SourceList.txt");
while ($line = <IN>) {
        if($line =~ /$checkname/){
                #($a,$b,$RAh,$RAm,$RAs,$Decd,$Decm,$Decs,$i,$j) = split (/\s+/, $line);
                ($Name1,$Name2,$RAh,$RAm,$RAs,$Decd,$Decm,$Decs,$Vlsr) = split (/\s+/, $line);
                @RA = ($RAh,$RAm,$RAs);
                @Dec = ($Decd,$Decm,$Decs);
                #@Vlsr = $i;
                #@int = $j;
#       }
#}
#close(IN);
print "<tr><td valign=top>Coordinate : </td><td>\n";
print "R.A. = @RA<br>\n";
print "Dec. = @Dec ( epoch : 2000 )<br>\n";
#print "</td><td valign=bottom>\n";
#print "(epoch = 2000)\n";
print "</td></tr>\n";
print "<tr><td>System Velocity : </td><td>";
print "Vlsr = $Vlsr km\/s\n";
print "</td></tr>\n";
#^[$B$3$N^[(Bflux^[$B$O2?$NCM$J$N$+!)Dj5A$7$F$+$iI=<($9$k$3$H^[(B
#print "<tr><td>Flux : </td><td>";
#print "@int Jy\n";
#print "</td></tr>\n";

#^[$B;2>HEEGH8;$rI=<(^[(B
print "<tr><td valign=top>Reference : </td><td>\n";
print "<table><tr><td>\n";
print "Sep[deg]</td><td>Name</td><td>RA(J2000)HMS</td><td>DEC(J2000)DMS</td><td>XT XU ST SU[mJy]</td></tr>\n";
#mJy]</td></tr>\n";
#^[$B;2>HEEGH8;$rI=<(^[(B
print "<tr><td valign=top>Reference : </td><td>\n";
print "<table><tr><td>\n";
print "Sep[deg]</td><td>Name</td><td>RA(J2000)HMS</td><td>DEC(J2000)DMS</td><td>XT XU ST SU[mJy]</td></tr>\n";
#mJy]</td></tr>\n";

#^[$B1_<~N($rDj5A^[(B
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ); }
$pai = atan2(1.0,1.0)*4;

#^[$BE7BN$N:BI8$r%i%8%"%s$KJQ49^[(B
$RAr = ($RAh + $RAm/60 + $RAs/3600) * $pai/12;
if($Decd >= 0){
        $Decr = ($Decd + $Decm/60 + $Decs/3600) * $pai/180;
}else{
        $Decd = -1*$Decd;
        $Decr = ($Decd + $Decm/60 + $Decs/3600) * $pai/180;
        $Decr = -1*$Decr;
}

#vlbaCalib.txt^[$B$+$i^[(B2.2^[$B!k0JFb$N;2>HEEGH8;$rA*=P^[(B
###open(IN,"/web/OVO/list/vlbaCalib.txt");
open(IN,"$list/vlbaCalib.txt");
@line = <IN>;
chomp @line;
close(IN);
foreach $line (@line){
        if($line =~ /\#/){
        }else{
                ($name1,$name2,$raall,$decall,$EWerr,$NSerr,$XT,$XU,$ST,$SU,$Cat) = split (/[ \t\s]+/, $line);
                ($rh,$rms) = split (/h/, $raall);
                ($rm,$rs) = split (/m/, $rms);
                $rs =~ s/s//;
                ($dd,$dms) = split (/d/, $decall);
                ($dm,$ds) = split (/\'/, $dms);
                $ds =~ s/\"//;
                $ra = ($rh + $rm/60 + $rs/3600) * $pai/12;
                if($dd >= 0){
                        $dec = ($dd + $dm/60 + $ds/3600) * $pai/180;
                }else{
                        $dd = -1*$dd;
                        $dec = ($dd + $dm/60 + $ds/3600) * $pai/180;
                        $dec = -1*$dec;
                }
                $d = sin($Decr)*sin($dec)+cos($Decr)*cos($dec)*cos($RAr-$ra);
                $sep = &acos($d);
                if($sep > $pai/600 and $sep < $pai/81.81818){
                        $sep = $sep*180/$pai;
                        $sep = sprintf ("%.3f",$sep);
                        print "<tr><td>$sep</td><td>$name1</td><td>$raall</td><td>$decall</td><td>$XT $XU $ST $SU</td></tr>\n";
                }
        }
}
print "</table>\n";

#print "Name RA(J2000)HMS DEC(J2000)DMS XT XU ST SU(mJy) sep(deg)<br>\n";
#open(IN, "../../OVO/list/SourceList2.txt");
#while ($line = <IN>) {
#       if($line =~ /$checkname/){
#               ($a,$b,$c,$d,$e,$f,$g,$h,$i,$j,$k,$l,$m,$n,$o,$p,$q,$r,$s) = split (/\s+/, $line);
#               @ref = ($k,$l,$m,$n,$o,$p,$q,$s);
#               print "@ref<br>\n";
#       }
#}
#Sourcelist2^[$B$K3:Ev$7$J$$^[(Bcheckname^[$B$G?J$a$k$H;2>HEEGH$NN%3Q7W;;$,@5$7$/$G$-$J$$$N$G!"^[(B
#if^[$B$N^[(B{}^[$BHO0O$rJQ99^[(B
        }
}
close(IN);

print "</td></tr></table>\n";
#^[$B%i%$%H%+!<%V$N2hA|$rI=<(^[(B
$checkname =~ s/\\//g;
###if(-e "../../OVO/data/$checkname/H2O"){
if(-e "$data/$checkname/H2O"){
        print "H2O maser <a href=\"./makeDLH2O.cgi?object=$checkname\">data DL</a><br>\n";
        #H2O spectrum
###        print "<a href=\"./makeimageH2O.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of H2O\" src=\"../../OVO/data/$checkname/H2O/$checkname-sp.png\"></a>\n";
        print "<a href=\"./makeimageH2O.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of H2O\" src=\"$address/$checkname/H2O/$checkname-sp.png\"></a>\n";
        #H2O lightcurve
###        print "<a href=\"../../OVO/data/$checkname/H2O/$checkname-lc.png\"><img width=\"200\" alt=\"Light Curve of H2O\" src=\"../../OVO/data/$checkname/H2O/$checkname-lc.png\"></a><br>\n";
        print "<a href=\"$address/$checkname/H2O/$checkname-lc.png\"><img width=\"200\" alt=\"Light Curve of H2O\" src=\"$address/$checkname/H2O/$checkname-lc.png\"></a><br>\n";
}
###if(-e "../../OVO/data/$checkname/SiO"){
if(-e "$data/$checkname/SiO"){
        print "SiO maser data DL <a href=\"./makeDLSiOv1.cgi?object=$checkname\">v1</a> <a href=\"./makeDLSiOv2.cgi?object=$checkname\">v2</a><br>\n";
        #SiO spectrum v1
###        print "<a href=\"./makeimageSiOv1.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of SiO v=1\" src=\"../../OVO/data/$checkname/SiO/$checkname-spv1.png\"></a>\n";
       #SiO spectrum v2
###        print "<a href=\"./makeimageSiOv2.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of SiO v=2\" src=\"../../OVO/data/$checkname/SiO/$checkname-spv2.png\"></a>\n";
        print "<a href=\"./makeimageSiOv2.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of SiO v=2\" src=\"$address/$checkname/SiO/$checkname-spv2.png\"></a>\n";
        #SiO lightcurve
###        print "<a href=\"../../OVO/data/$checkname/SiO/$checkname-lc.png\"><img width=\"200\" alt=\"Light Curve of SiO\" src=\"../../OVO/data/$checkname/SiO/$checkname-lc.png\"></a><br>\n";
        print "<a href=\"$address/$checkname/SiO/$checkname-lc.png\"><img width=\"200\" alt=\"Light Curve of SiO\" src=\"$address/$checkname/SiO/$checkname-lc.png\"></a><br>\n";
}
print  "</body>\n";
print  "</html>\n";
