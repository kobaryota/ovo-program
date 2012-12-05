$Dold = "/home/ryota/Desktop/OVO-AUTO/old-singledata";	#singleの前回アップデート時のデータ場所
$Dnew = "/home/ryota/Desktop/OVO-AUTO/singledata";		#新しいsingleのデータ
$OVOAUTO = "/home/ryota/Desktop/OVO-AUTO";		#OVO-AUTO
$Dprg = "/home/ryota/Desktop/OVO-AUTO/program";

system("diff $Dold/ $Dnew/ > $Dprg/single.txt");	#前回のデータと新しいデータの差を表示

open(IN, "$Dprg/single.txt");
@file = <IN>;
chomp @file;
close(IN);

foreach $files (@file){
	($mae,$name) = split(/: /,$files);
	system("cp $Dnew/$name $OVOAUTO/kousindata\n");	#新しいデータを別のdirに移動
}

system("rsync -a $Dnew/ $Dold/");	#新しいデータに置き換える
