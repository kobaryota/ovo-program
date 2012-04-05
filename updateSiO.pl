#############################################################
## SiOメーザーのデータ更新プログラム
## OVO/inputboxにあるtxt（newstarの出力txt(header付)）を
## 各天体のdirに移動させ、gnuplotでライトカーブとスペクトルを
## 作成する。またリスト検索の更新も行う。
## cron等で定期的に走らせることを想定。
## 1st version 2007/5/10 last update 2008/10/23 by K.Ueda
#############################################################
##dir構造が複雑なのでフルパスを使うが、短く済むように定義
###$Dinp = "/web/OVO/inputbox";
###$Dpgm = "/web/OVO/program";
###$Ddat = "/web/OVO/data";######### change these lines ! ##########

$Dperl = "/usr/bin/perl";					## Please input a directory of perl ##
$Dhtml = "/Users/ovo/Sites/OVO";			## Please input a directory of html ##
$Dinp = "/Users/ovo/Sites/OVO/inputbox";	## Please input a directory of inputbox ##
$Dpgm = "/Users/ovo/Sites/OVO/program";		## Please input a directory of program ##
$Ddat = "/Users/ovo/Sites/OVO/data";		## Please input a directory of data ##

system("ls $Dinp/*Qv*MIZ.txt > $Dpgm/newdataQ.lst");
system("ls $Dinp/*Qv1*MIZ.txt > $Dpgm/newdataQv1.lst");
system("ls $Dinp/*Qv2*MIZ.txt > $Dpgm/newdataQv2.lst");

open(INv1,"$Dpgm/newdataQv1.lst");
@file1 = <INv1>;
chomp @file1;
close(INv1);
open(INv2,"$Dpgm/newdataQv2.lst");
@file2 = <INv2>;
chomp @file2;
close(INv2);

#inputbox内のtxtをv1v2毎に各天体のdirに移動。
#スペクトル図を作成
foreach $file1 (@file1){
	$file1 = substr($file1, 18);
	($name1,$ushiro1) = split (/\_Qv1\_/, $file1);
	system("mkdir -p $Ddat/$name1/SiO/v1/");
	system("mv $Dinp/$file1 $Ddat/$name1/SiO/v1/");
	$fileplt1 = $file1;
	$fileplt1 =~ s/txt/plt/;
        system("$Dperl $Dpgm/txt2sp.pl $Ddat/$name1/SiO/v1/$file1 > $Ddat/$name1/SiO/v1/$fileplt1");
	open(OUT1,">> plotspv1.sh");
        print(OUT1 "$Dperl $Dpgm/SPgnuplotSiOv1.pl $Ddat/$name1/SiO/v1/$fileplt1");
        close(OUT1);
        system("sh plotspv1.sh");
	system("ls $Ddat/$name1/SiO/v1/$name1\_20*.png | tail -1 > $name1-new.txt");
        open(IN1,"$name1-new.txt");
	$newpng1 = <IN1>;
        chomp $newpng1;
        close(IN1);
	system("cp $newpng1 $Ddat/$name1/SiO/$name1-spv1.png");
        system("ls -r $Ddat/$name1/SiO/v1/$name1\_20*.png > $Ddat/$name1/SiO/v1/$name1\_allsp.lst");
        system("ls -r $Ddat/$name1/SiO/v1/$name1\_Qv1*MIZ.txt > $Ddat/$name1/SiO/v1/$name1\_alltxt.lst");
	system("rm -f plotspv1.sh");
	system("rm -f $name1-new.txt");
}
foreach $file2 (@file2){
	$file2 = substr($file2, 18);
	($name2,$ushiro2) = split (/\_Qv2\_/, $file2);
	system("mkdir -p $Ddat/$name2/SiO/v2/");
	system("mv $Dinp/$file2 $Ddat/$name2/SiO/v2/");
	$fileplt2 = $file2;
	$fileplt2 =~ s/txt/plt/;
        system("$Dperl $Dpgm/txt2sp.pl $Ddat/$name2/SiO/v2/$file2 > $Ddat/$name2/SiO/v2/$fileplt2");
	open(OUT2,">> plotspv2.sh");
        print(OUT2 "$Dperl $Dpgm/SPgnuplotSiOv2.pl $Ddat/$name2/SiO/v2/$fileplt2");
        close(OUT2);
        system("sh plotspv2.sh");
	system("ls $Ddat/$name2/SiO/v2/$name2\_20*.png | tail -1 > $name2-new.txt");
        open(IN2,"$name2-new.txt");
	$newpng2 = <IN2>;
        chomp $newpng2;
        close(IN2);
	system("cp $newpng2 $Ddat/$name2/SiO/$name2-spv2.png");
        system("ls -r $Ddat/$name2/SiO/v2/$name2\_20*.png > $Ddat/$name2/SiO/v2/$name2\_allsp.lst");
        system("ls -r $Ddat/$name1/SiO/v2/$name1\_Qv2*MIZ.txt > $Ddat/$name1/SiO/v2/$name1\_alltxt.lst");
	system("rm -f plotspv2.sh");
	system("rm -f $name2-new.txt");
}

#ここまではv1v2それぞれで作業
#ここからはv1v2同時に行っていく
#各txtの最大強度の点を見付け、max.plで抜き出し、
#sortで時間順に並べ、plot用の*sort.pltを作る。
#また各プロットにSNR値を添えるための*label.pltも作成。
#↑SNRはやめてr.m.s.をエラーバーに。
open(IN,"$Dpgm/newdataQ.lst");
@file = <IN>;
chomp @file;
close(IN);
foreach $file (@file){
	$file = substr($file, 18);
	($name,$ushiro) = split (/\_Qv/, $file);
	system("ls $Ddat/$name/SiO/v1/*MIZ.txt > $name-v1junbi.txt");
	system("ls $Ddat/$name/SiO/v2/*MIZ.txt > $name-v2junbi.txt");
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
		print(OUT1 "$Dperl $Dpgm/max.pl $data1\n");
		close(OUT1);
	}
	foreach $data2 (@data2){
		open(OUT2,">> $name-v2get.sh");
		print(OUT2 "$Dperl $Dpgm/max.pl $data2\n");
		close(OUT2);
	}
	system("sh $name-v1get.sh > $name-v1plot.txt");
	system("sh $name-v2get.sh > $name-v2plot.txt");
	system("sort $name-v1plot.txt > $Ddat/$name/SiO/v1/$name-sortv1.plt");
	system("sort $name-v2plot.txt > $Ddat/$name/SiO/v2/$name-sortv2.plt");
	system("rm -f $name-*");
	#system("/usr/bin/perl $Dpgm/makelabel.pl $Ddat/$name/SiO/$name-sortv1.plt");
	#system("/usr/bin/perl $Dpgm/makelabel.pl $Ddat/$name/SiO/$name-sortv2.plt");
	#system("mv label.plt $Ddat/$name/SiO/$name-label.plt");
#gnuplot.plでplotさせるためのshを作成、実行。
	open(OUT0,">> plot.sh");
	print(OUT0 "$Dperl $Dpgm/LCgnuplotSiO.pl $name\n");
	close(OUT0);
	system("sh plot.sh");
	system("rm -f plot.sh");
}

#SiOリストの更新
system("$Dperl $Dpgm/makelistSiO.pl > $Dhtml/SiOmaser.html");
system("rm -f newdata*.lst");
