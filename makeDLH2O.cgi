#!/usr/local/bin/perl
print "Content-type: text/html; charset=euc-jp";
print "Content-type: image/png\n\n";

##$object��ŷ�Τ���text��ɽ������HTML������
##2008/08/28
##last update 2009/09/15 by S.Shiozaki
##can't use [system] in cgi??

$data = "/home/ryota/Desktop/OVO-AUTO/HTML/data";    ##Please input a directry of maser source data##
$address = "http://localhost/data";       ##Please input a address of maser source data##

#link������value��$object�˳�Ǽ
use CGI qw(param);
$object = param('object');
chomp $object;
#cgi���𤹤��Ȥʤ���+���ä����Τ�IRAS��+���ղ
if($object =~ /IRAS/){
        #print "$object\n";
        $space = substr($object, 9, 1);
        #print "$space\n";
if($space =~ /\s/){
                substr($object, 9, 1) = "\+";
                $object =~ s/\s//g;
        }else{
                $object =~ s/\s//g;
        }
}
print "<html>\n";
print "<head>\n";
print "<title>All Text Data of $object</title></head>\n";
print "<body>\n";
print "<h2>All Text Data of $object</h2>\n";
#system("ls ../../OVO/data/$object/H2O/$object\_200*.png > ../../OVO/data/$object/H2O/allsp.lst");
###open(IN,"../../OVO/data/$object/H2O/$object\_alltxt.lst");
open(IN,"$data/$object/H2O/$object\_alltxt.lst");
while($sp = <IN>){
        chomp $sp;
        ($mae,$pass)=split(/\/data\//,$sp);
        ($fullpass,$filename)=split(/\/H2O\//,$sp);
        ($amari,$nokori)=split(/\_K\_/,$sp);
        ($date,$ushiro)=split(/IRK/,$nokori);
        $year = substr($date,0,2);
        $month = substr($date,2,2);
        $day = substr($date,4,2);
#       $sp =~ s/\/web/http:\/\/astro.sci.kagoshima-u.ac.jp/;
###     print "$day<br><a href=\"$sp\">$sp</a><br>\n";
        print "#Observation date  $year/$month/$day<br><a href=\"$address/$pass\">$filename</a><br><br>\n";
        #print "<img alt=\"$sp\" src=\"$sp\"><br>\n";
}
print  "</body>\n";
print  "</html>\n";

