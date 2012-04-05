#!/usr/bin/perl

$Dperl = "/usr/bin/perl";                       ## Please input a directory of perl ##
$Dhtml = "/Users/ovo/Sites/OVO";                ## Please input a directory of html ##
$Dpgm = "/Users/ovo/Sites/OVO/program";         ## Please input a directory of program ##
$Ddat = "/Users/ovo/Sites/OVO/data";            ## Please input a directory of data ##
$Dinp = "/Users/ovo/Sites/OVO/inputbox";	## Please input a directory of inputbox ##

#system("ls $Dinp/*IRK.txt > $Dpgm/newdata.lst");
#open(IN,"$Dpgm/newdata.lst");
#@file = <IN>;
#chomp @file;
#close(IN);

system("ls $Ddat/ > $Dpgm/AllSourceName.lst");
open(IN10,"$Dpgm/AllSourceName.lst");
@name1 = <IN10>;
chomp @name1;
close(IN10);
foreach $name1 (@name1){
#	system("ls $Ddat/$name1/H2O/*IRK.txt > $name1-junbi.txt");
#	open(INa,"$name1-junbi.txt");
#	@data1 = <IN11>;
#	chomp @data1;
#	close(IN11);
#	foreach $data1 (@data1){
#		open(OUT10,">> $name1-get.sh");
#		print(OUT10 "$Dperl $Dpgm/max.pl $data1\n");
#		close(OUT10);
#	}
#	system("sh $name1-get.sh > $name1-plot.txt");
#	system("sort $name1-plot.txt > $Ddat/$name1/H2O/$name1-sort.plt");
#	system("rm -f $name1-*");
#	open(OUT11,">> plot11.sh");
#	print(OUT11 "$Dperl $Dpgm/LCgnuplotH2O.pl $Ddat/$name1/H2O/$name1-sort.plt\n");
#	close(OUT11);
#	system("sh plot11.sh");
#	system("rm -f plot11.sh");
#	$filesp1 = $file1;
#	$filesp1 =~ s/txt/plt/;
#	system("$Dperl $Dpgm/txt2sp.pl $Ddat/$name1/H2O/$file1 > $Ddat/$name1/H2O/$filesp1");
#	open(OUT12,">> plot12.sh");
#	print(OUT12 "$Dperl $Dpgm/SPgnuplotH2O.pl $Ddat/$name1/H2O/$filesp1");
#	close(OUT12);
#	system("sh plot12.sh");
	system("ls $Ddat/$name1/H2O/$name1\_20*.png | tail -1 > $name1-new.txt");
	open(IN12,"$name1-new.txt");
	$newpng1 = <IN12>;
	chomp $newpng1;
	close(IN12);
	system("cp $newpng1 $Ddat/$name1/H2O/$name1-sp.png");
	system("ls -r $Ddat/$name1/H2O/$name1\_20*.png > $Ddat/$name1/H2O/$name1\_allsp.lst");
	system("ls -r $Ddat/$name1/H2O/$name1\_K*IRK.txt > $Ddat/$name1/H2O/$name1\_alltxt.lst");
#	system("rm -f plot12.sh");
	system("rm -f $name1-new.txt");
}
#system("$Dperl $Dpgm/makelistH2O.pl > $Dhtml/H2Omaser.html");

