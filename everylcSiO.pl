# 1st version 2007/5/10 last update 2008/09/03 by K.Ueda
#############################################################
#ここからはv1v2同時に行っていく
#各txtの最大強度の点を見付け、max.plで抜き出し、
#sortで時間順に並べ、plot用の*sort.pltを作る。
#また各プロットにSNR値を添えるための*label.pltも作成。
open(IN,"/web/OVO/program/newdata.lst");
@file = <IN>;
chomp @file;
close(IN);
foreach $name (@file){
	#$file = substr($file, 18);
	#($name,$ushiro) = split (/\_Qv/, $file);
	system("ls /web/OVO/data/$name/SiO/v1/*MIZ.txt > $name-v1junbi.txt");
	system("ls /web/OVO/data/$name/SiO/v2/*MIZ.txt > $name-v2junbi.txt");
	open(IN1,"$name-v1junbi.txt");
	open(IN2,"$name-v2junbi.txt");
	@data1 = <IN1>;
	@data2 = <IN2>;
	chomp @data1;
	chomp @data2;
	close(IN1);
	close(IN2);
	foreach $data1 (@data1){
		open(OUT1,">> $name-v1get.sh");
		print(OUT1 "/usr/bin/perl /web/OVO/program/max.pl $data1\n");
		close(OUT1);
	}
	foreach $data2 (@data2){
		open(OUT2,">> $name-v2get.sh");
		print(OUT2 "/usr/bin/perl /web/OVO/program/max.pl $data2\n");
		close(OUT2);
	}
	system("sh $name-v1get.sh > $name-v1plot.txt");
	system("sh $name-v2get.sh > $name-v2plot.txt");
	system("sort $name-v1plot.txt > /web/OVO/data/$name/SiO/v1/$name-sortv1.plt");
	system("sort $name-v2plot.txt > /web/OVO/data/$name/SiO/v2/$name-sortv2.plt");
	system("rm -f $name-*");
	#system("/usr/bin/perl /web/OVO/program/makelabel.pl /web/OVO/data/$name/SiO/$name-sortv1.plt");
	#system("/usr/bin/perl /web/OVO/program/makelabel.pl /web/OVO/data/$name/SiO/$name-sortv2.plt");
	#system("mv label.plt /web/OVO/data/$name/SiO/$name-label.plt");
#gnuplot.plでplotさせるためのshを作成、実行。
	open(OUT0,">> plot.sh");
	print(OUT0 "/usr/bin/perl /web/OVO/program/LCgnuplotSiO.pl $name\n");
	close(OUT0);
	system("sh plot.sh");
	system("rm -f plot.sh");
}
