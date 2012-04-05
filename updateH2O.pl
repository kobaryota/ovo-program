#############################################################
## H2Oメーザーのデータ更新プログラム
## OVO/inputboxにあるtxt（newstarの出力txt(header付)）を
## 各天体のdirに移動させ、gnuplotでライトカーブとスペクトルを
## 作成する。またリスト検索の更新も行う。
## cron等で定期的に走らせることを想定。
## 1st version 2007/5/10 last update 2008/10/22 by K.Ueda
#############################################################
##dir構造が複雑なのでフルパスを使うが、短く済むように定義
###$Dinp = "/web/OVO/inputbox";
###$Dpgm = "/web/OVO/program";
###$Ddat = "/web/OVO/data";######### change these lines ! ##########


$Dperl = "/usr/bin/perl";			## Please input a directory of perl ##
$Dhtml = "/Users/sio/ovo/OVO";		## Please input a directory of html ##
$Dinp = "/Users/sio/ovo/OVO/inputbox";	## Please input a directory of inputbox ##
$Dpgm = "/Users/sio/ovo/OVO/program";	## Please input a directory of program ##
$Ddat = "/Users/sio/ovo/OVO/data";		## Please input a directory of data ##

##inputbox内のtxtを読み込む
system("ls $Dinp/*IRK.txt > $Dpgm/newdata.lst");
open(IN,"$Dpgm/newdata.lst");
@file = <IN>;
chomp @file;
close(IN);

##inputbox内のtxtを各天体のdirに移動
foreach $files (@file){
###	$file = substr($file, 18);#########←change this line ! #########
###	$file = substr($file, 30);
	($maepass,$file) = split (/\/inputbox\//, $files);
	($name,$ushiro) = split (/\_K\_/, $file);
	system("mkdir -p $Ddat/$name/H2O/");
	system("mv $Dinp/$file $Ddat/$name/H2O/");
	
##ライトカーブ作成
##各txtの最大強度の点を見付け、max.plで抜き出し、
##sortで時間順に並べ、plot用の*sort.pltを作る。
##また各プロットにSNR値を添えるための*label.pltも作成。
##↑SNRはやめてr.m.s.をエラーバーに。
	system("ls $Ddat/$name/H2O/*IRK.txt > $name-junbi.txt");
	open(IN1,"$name-junbi.txt");
	@data = <IN1>;
	chomp @data;
	close(IN1);
	foreach $data (@data){
		open(OUT,">> $name-get.sh");
		print(OUT "$Dperl $Dpgm/max.pl $data\n");
		close(OUT);
	}
	system("sh $name-get.sh > $name-plot.txt");
	system("sort $name-plot.txt > $Ddat/$name/H2O/$name-sort.plt");
	system("rm -f $name-*");
	#system("$Dperl $Dpgm/makelabel.pl $Ddat/$name/H2O/$name-sort.plt");
	#system("mv label.plt $Ddat/$name/H2O/$name-label.plt");
##gnuplot.plでplotさせるためのshを作成、実行。
	open(OUT0,">> plot.sh");
	print(OUT0 "$Dperl $Dpgm/LCgnuplotH2O.pl $Ddat/$name/H2O/$name-sort.plt\n");
	close(OUT0);
	system("sh plot.sh");
#	system("rm -f plot.sh");
	
##最新＆全スペクトル図を作成する。
##古いデータを追加しても対応できるように変更
	#system("ls $Ddat/$name/H2O/$name*IRK.txt | tail -1 > $name-new.txt");
	#open(IN2,"$name-new.txt");
	#$newtxt = <IN2>;
	#chomp $newtxt;
	#($getday) = split (/IRK/, $newtxt);
	#($pwd,$day) = split (/\_K\_/, $getday);
	#close(IN2);
	#system("$Dperl $Dpgm/txt2sp.pl $newtxt > $Ddat/$name/H2O/$name-newsp.plt");
	$filesp = $file;
	$filesp =~ s/txt/plt/;
	system("$Dperl $Dpgm/txt2sp.pl $Ddat/$name/H2O/$file > $Ddat/$name/H2O/$filesp");
	open(OUT2,">> plot2.sh");
	print(OUT2 "$Dperl $Dpgm/SPgnuplotH2O.pl $Ddat/$name/H2O/$filesp\n");
	close(OUT2);
	system("sh plot2.sh");
	system("ls $Ddat/$name/H2O/$name\_20*.png | tail -1 > $name-new.txt");
	open(IN2,"$name-new.txt");
	$newpng = <IN2>;
	chomp $newpng;
	close(IN2);
	system("cp $newpng $Ddat/$name/H2O/$name-sp.png");
	system("ls -r $Ddat/$name/H2O/$name\_20*.png > $Ddat/$name/H2O/$name\_allsp.lst");
	system("ls -r $Ddat/$name/H2O/$name\_K*IRK.txt > $Ddat/$name/H2O/$name\_alltxt.lst");
	system("rm -f plot2.sh");
	system("rm -f $name-new.txt");
}
###system("$Dperl $Dpgm/makelistH2O.pl > /web/OVO/H2Omaser.html");####change this line !###
system("$Dperl $Dpgm/makelistH2O.pl > $Dhtml/H2Omaser.html");
