###変換名一覧中に2つ以上一致するものがあった場合の対応が不完全
###shファイル等に吐き出して、目視確認が必要
###該当無しの場合は、nohitに移動されるので確認し、変換名一覧を充実させる
#!/usr/bin/perl
system("ls *Qv*.txt > sample.txt");
#$banda = "_Qv";
$no = 0;
print "mkdir -p nonhit\n";
open(IN,"sample.txt");					#解析結果txtの一覧を読み込む。
while ($line = <IN>)  {
	chomp $line;
	if(grep /Qv1/, $line){$banda = "_Qv1_";$bandb = "_Qv1_";}
	if(grep /Qv2/, $line){$banda = "_Qv2_";$bandb = "_Qv2_";}
	($name,$ushiro) = split (/\_Qv.\_/, $line);		#_K_の前後で分ける。
#	($nameQ,$ushiro) = split (/\Qv/, $line);		#_K_の前後で分ける。
	$name =~ s/\+/\\\+/c;				#+が上手く認識されないため\を付ける。
#	$nameQ =~ s/\+/\\\+/c;				#+が上手く認識されないため\を付ける。
#	if($nameQ=~/Q_/){
#		($name,$Qdami)=split(/Q_/,$nameQ);
#		$bandb = "Q_Qv";
#	}else{
#		($name,$Qdami)=split(/_/,$nameQ);
#		$bandb = "_Qv";
#	}
	$ushiro =~ s/\*//;				#ファイル名の最後に*が付いている場合は消す。
	open(IN2,"/Users/sio/ovo/OVO/program/allrename.txt");#変換名一覧を読み込む。
	while ($pattern = <IN2>){
		chomp $pattern;
		if($pattern =~ / $name,/i){		#スペースと,に囲まれた天体名を大小文字区別せず一覧と比較
			++$no;				#一致するものがあればnoに1を足す
			if($no == 1){			#noが1、つまり一致したものが1つなら
				($real,$two) = split (/,\s/,$pattern);
				$name =~ s/\\//g;	#+を認識させるための\を消す
				$real =~ s/ //;		
				print "cp $name$bandb$ushiro $real$banda$ushiro\n";	#ファイル名変換
				print "mv $real$banda$ushiro \/Users\/sio\/ovo\/OVO\/inputbox\/\n";	#inputboxにcopy
			}
			if($no >= 2){
				print "-----------attention!! $name is double booking!-------------\n";	#一致するものが2つ以上ある場合、警告文
#				print "mv $name$band$ushiro nonhit\n\n"
				print "mv $name$banda$ushiro nonhit\n\n"
			}	
		}
	}
	close(IN2);
	if($no == 0){				#一致するものが無い場合
		$name =~ s/\\//g;
		print "mv $name$bandb$ushiro nonhit\n";	#nohitというdirに転送
	}
	$no = 0;
}
close(IN);
system("rm sample.txt");
