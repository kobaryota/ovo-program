open(IN,"newdata.lst");
@file = <IN>;
chomp @file;
close(IN);
foreach $name (@file){
	chomp $name;
#��txt�κ��綯�٤������դ���max.pl��ȴ���Ф���
#sort�ǻ��ֽ���¤١�plot�Ѥ�*sort.plt���롣
#�ޤ��ƥץ�åȤ�SNR�ͤ�ź���뤿���*label.plt�������
#��SNR�Ϥ���r.m.s.�򥨥顼�С��ˡ�
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
#gnuplot.pl��plot�����뤿���sh��������¹ԡ�
	open(OUT0,">> plot.sh");
	print(OUT0 "/usr/bin/perl /web/OVO/program/LCgnuplotH2O.pl /web/OVO/data/$name/H2O/$name-sort.plt\n");
	close(OUT0);
	system("sh plot.sh");
	system("rm -f plot.sh");
}
