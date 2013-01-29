#!/usr/local/bin/perl
print "Content-type: text/html; charset=euc-jp";
print "Content-type: image/png\n\n";

##$object��ŷ�Τ������ڥ��ȥ��ޤ�ɽ������HTML������
##last update 2009/09/15 by S.Shiozaki
##can't use [system] in cgi??

$data = "/home/ryota/Desktop/OVO-AUTO/HTML/data";    ##Please designate a directry of maser source data##
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
print "<title>All Spectrum of $object</title></head>\n";
print "<body>\n";
print "<h2>All Spectrum of $object</h2>\n";
#system("ls ../../OVO/data/$object/H2O/$object\_200*.png > ../../OVO/data/$object/H2O/allsp.lst");
###open(IN,"../../OVO/data/$object/H2O/$object\_allsp.lst");
open(IN,"$data/$object/H2O/$object\_allsp.lst");
while($sp = <IN>){
        chomp $sp;
        #substr($sp, 0, 4) = "../..";
        ($mae,$pass)=split(/\/data\//,$sp);
        ($fullpass,$filename)=split(/\/H2O\//,$sp);
        ($amari,$nokori)=split(/$object\_/,$sp);
        ($date,$ushiro)=split(/\.pn/,$nokori);
###        $year = substr($date,0,4);
###        $month = substr($date,4,2);
###        $day = substr($date,6,2);
#print "<img alt=\"$sp\" src=\"http://astro.sci.kagoshima-u.ac.jp/OVO/data/$object/H2O/$sp\"><br>\n";
###     print "<img alt=\"$sp\" src=\"$sp\"><br>\n";
        print "<br><img alt=\"$address/$pass\" src=\"$address/$pass\"><br><br>\n";
}
print  "</body>\n";
print  "</html>\n";

