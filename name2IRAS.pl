###変換名一覧中に2つ以上一致するものがあった場合の対応が不完全
###shファイル等に吐き出して、目視確認が必要
###該当無しの場合は、nohitに移動されるので確認し、変換名一覧を充実させる
#!/usr/bin/perl
system("ls *.txt > sample.txt");
$band = "\_K\_";
$no = 0;
print "mkdir nonhit\n";
open(IN,"sample.txt");					#解析結果txtの一覧を読み込む。
while ($line = <IN>)  {
	chomp $line;
	($name,$ushiro) = split (/\_K\_/, $line);	#_K_の前後で分ける。
	$name =~ s/\+/\\\+/c;				#+が上手く認識されないため\を付ける。
	$ushiro =~ s/\*//;				#ファイル名の最後に*が付いている場合は消す。
	open(IN2,"/home/ryota/ovo/OVO/program/allrename.txt");#変換名一覧を読み込む。
	while ($pattern = <IN2>){
		chomp $pattern;
		if($pattern =~ / $name,/i){		#スペースと,に囲まれた天体名を大小文字区別せず一覧と比較
			++$no;				#一致するものがあればnoに1を足す
			if($no == 1){			#noが1、つまり一致したものが1つなら
				($real,$two) = split (/,\s/,$pattern);
				$name =~ s/\\//g;	#+を認識させるための\を消す
				$real =~ s/ //;		
				print "cp $name$band$ushiro $real$band$ushiro\n";	#ファイル名変換
				print "mv $real$band$ushiro \/home\/ryota\/ovo\/OVO\/inputbox\/\n";	#inputboxにcopy
#				print "mv $real$band$ushiro \/Volumes\/sioHD\/ovo\/OVO\/inputbox\/\n";	#inputboxにcopy
			}
			if($no >= 2){
				print "-----------attention!! $name is double booking!-------------\n";	#一致するものが2つ以上ある場合、警告文
				print "mv $name$band$ushiro nonhit\n\n"
			}	
		}
	}
	close(IN2);
	if($no == 0){				#一致するものが無い場合
		$name =~ s/\\//g;
		print "mv $name$band$ushiro nonhit\n";	#nohitというdirに転送
	}
	$no = 0;
}
close(IN);
system("rm sample.txt");
