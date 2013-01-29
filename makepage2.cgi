#!/usr/local/bin/perl

##last update 2009/09/15 by S.Shoizaki

$data = "/home/ryota/Desktop/OVO-AUTO/HTML/data";    ##Please input a directry of maser source data##
$address = "http://localhost/data";       ##Please input a address of maser source data##
$list = "/home/ryota/Desktop/OVO-AUTO/list";    ##Please input a directry of list##

print "Content-type: text/html; charset=euc-jp";
print "Content-type: image/png\n\n";

print  "<html>\n";
print  "<head>\n";
print  "<title>objest infomation</title></head>\n";
print  "<body>\n";

use CGI qw(param);
$object = param('object');

#print "$object";

$no = 0;
if($object =~ /IRAS/){
        $space = substr($object, 9, 3);
        if($space =~ /\s/){
                substr($object, 10, 1) = "\\\+";
        }
}

else{
	if($object =~ /\s/){
		$object =~ s/\s+/+/g;
        }
}

#if($object =~ /J/){
#        $space = substr($object, 7, 3);
#        if($space =~ /\s/){
#                substr($object, 8, 1) = "\\\+";
#        }
#}

print "<table>\n";
open(IN,"$list/NameList.txt");
while ($line = <IN>) {
        chomp $line;
        if($line =~ / $object,/i){
                ($checkname) = split (/\s+/, $line);
                $object =~ s/\\//g;
                print  "<p><h2>profile of $object</h2>\n";
                print  "</p>\n";
                $line =~ s/(?:.+\s\s)//g;
                @name = split (/,/, $line);
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


if($no eq 0){
        $object =~ s/\\//g;
        $object =~ s/ //g;
        $checkname = $object;
        print  "<p><h2>profile of $object</h2>\n";
        print "<tr><td valign=top>Identifier : </td><td>\n";
        print "$checkname</td></tr>\n";

}

$checkname =~ s/\+/\\\+/g;

open(IN, "$list/sort-SourceList.txt");
while ($line = <IN>) {
        if($line =~ /$checkname/){
                ($Name1,$Name2,$RAh,$RAm,$RAs,$Decd,$Decm,$Decs,$Vlsr) = split (/\s+/, $line);
                @RA = ($RAh,$RAm,$RAs);
                @Dec = ($Decd,$Decm,$Decs);

print "<tr><td valign=top>Coordinate : </td><td>\n";
print "R.A. = @RA<br>\n";
print "Dec. = @Dec ( epoch : 2000 )<br>\n";
print "</td></tr>\n";
print "<tr><td>System Velocity : </td><td>";
print "Vlsr = $Vlsr km\/s\n";
print "</td></tr>";

print "<tr><td valign=top>Reference : </td><td>\n";
print "<table><tr><td>\n";
print "Sep[deg]</td><td>Name</td><td>RA(J2000)HMS</td><td>DEC(J2000)DMS</td><td>XT XU ST SU[mJy]</td></tr>\n";

sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ); }
$pai = atan2(1.0,1.0)*4;
$RAr = ($RAh + $RAm/60 + $RAs/3600) * $pai/12;
if($Decd >= 0){
        $Decr = ($Decd + $Decm/60 + $Decs/3600) * $pai/180;
}else{
        $Decd = -1*$Decd;
        $Decr = ($Decd + $Decm/60 + $Decs/3600) * $pai/180;
        $Decr = -1*$Decr;
}

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

        }
}
close(IN);
print "</td></tr></table>\n";

$checkname =~ s/\\//g;

if(-e "$data/$checkname/H2O"){
        print "H2O maser <a href=\"./makeDLH2O.cgi?object=$checkname\">data DL</a><br>\n";

        print "<a href=\"./makeimageH2O.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of H2O\" src=\"$address/$checkname/H2O/$checkname-sp.png\"></a>\n";

        print "<a href=\"$address/$checkname/H2O/$checkname-lc.png\"><img width=\"200\" alt=\"Light Curve of H2O\" src=\"$address/$checkname/H2O/$checkname-lc.png\"></a><br>\n";
}

if(-e "$data/$checkname/SiO"){
        print "SiO maser data DL <a href=\"./makeDLSiOv1.cgi?object=$checkname\">v1</a> <a href=\"./makeDLSiOv2.cgi?object=$checkname\">v2</a><br>\n";

        print "<a href=\"./makeimageSiOv1.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of SiO v=1\" src=\"$address/$checkname/SiO/$checkname-spv1.png\"></a>\n";

        print "<a href=\"./makeimageSiOv2.cgi?object=$checkname\"><img width=\"200\" alt=\"Spectrum of SiO v=2\" src=\"$address/$checkname/SiO/$checkname-spv2.png\"></a>\n";

        print "<a href=\"$address/$checkname/SiO/$checkname-lc.png\"><img width=\"200\" alt=\"Light Curve of SiO\" src=\"$address/$checkname/SiO/$checkname-lc.png\"></a><br>\n";
}
print  "</body>\n";
print  "</html>\n";

