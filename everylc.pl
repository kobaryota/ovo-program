open(IN,"newdata.lst");
@file = <IN>;
chomp @file;
close(IN);
foreach $name (@file){
	chomp $name;
#各txtの最大強度の点を見付け、max.plで抜き出し、
#sortで時間順に並べ、plot用の*sort.pltを作る。
#また各プロットにSNR値を添えるための*label.pltも作成。
#↑SNRはやめてr.m.s.をエラーバーに。
	system("ls /web/OVO/data/$name/H2O/*IRK.txt > $name-junbi.txt");
	open(IN1,"$name-junbi.txt");
	@data = <IN1>;
	chomp @data;
	close(IN1);
	foreach $data (@data){
		open(OUT,">> $name-get.sh");
		print(OUT "/usr/bin/perl /web/OVO/program/max.pl $data\n");
		close(OUT);
	}
	system("sh $name-get.sh > $name-plot.txt");
	system("sort $name-plot.txt > /web/OVO/data/$name/H2O/$name-sort.plt");
	system("rm -f $name-*");
#gnuplot.plでplotさせるためのshを作成、実行。
	open(OUT0,">> plot.sh");
	print(OUT0 "/usr/bin/perl /web/OVO/program/LCgnuplotH2O.pl /web/OVO/data/$name/H2O/$name-sort.plt\n");
	close(OUT0);
	system("sh plot.sh");
	system("rm -f plot.sh");
}
