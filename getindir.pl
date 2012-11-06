#!/usr/bin/perl
$Ddata = "/home/ryota/Desktop";##"/home/verausr/DATA_vera2txt_RESULT"; ##データが保存されている場所
$Dido = "opertion";##"verausr@oper-irk:/home/verausr/koba";   ##データを移動させたい場所 

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon += 1;
print "$year年$mon月$mday日\n";

system("ls $Ddata/*txt > $Ddata/tentai.lst");
open(IN,"$Ddata/tentai.lst");
@file = <IN>;
chomp @file;
close(IN);

system("rm $Ddata/oper-idou.sh");

while () {
foreach $files (@file){
  open(OUT,">> $Ddata/oper-idou.sh");
	print(OUT "scp $files $Dido\n");
	print(OUT "mv $files $Ddata/$year$mon\n");
	}
	close(OUT);

system("sh $Ddata/oper-idou.sh");
}