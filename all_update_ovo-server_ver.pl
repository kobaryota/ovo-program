#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use File::Path;

my $Dperl = "/usr/bin/perl";
my $Dinp = "/Users/ovo/Sites/OVO/inputbox";
my $Ddat = "/Users/ovo/Sites/OVO/data";
my $Dpgm = "/Users/ovo/Sites/OVO/program";
my $Dlist = "/Users/ovo/Sites/OVO/list";
my $Dhtml = "/Users/ovo/Sites/OVO";

#	my $gnuplot = '/usr/local/bin/gnuplot -persist';
#これも変更！！



###########################################################
###########################################################
#
#データファイルをそれぞれのディレクトリ($Ddat/$name/$band_path/)に移動し、
#プロット用ファイル(.plt)、を作成
#
###########################################################
###########################################################

# data内の天体を列挙
my @file_list = glob("$Ddat/*");
chomp @file_list;

my @source_names;


# バンドの選択
my $band_name;
my $band_path;
my $band_v;
my $band_txt;

print "Please type kind of the need to update band.\n";
print " \(ex. H2O => K(or k), SiO=> Qv1(or qv1) or Qv2(or qv2) \)\n";

my $band = <STDIN>;
if($band =~ /K/i){
	$band_name = "H_\{2\}O";
	$band_path = "H2O";
	$band_v = "";
	$band_txt = "*_K_*IRK.txt";
}
elsif($band =~ /Qv1/i){
	$band_name = "SiO";
	$band_path = "SiO/v1";
	$band_v = " v = 1";
	$band_txt = "*_Qv1_*MIZ.txt";
}
elsif($band =~ /Qv2/i){
	$band_name = "SiO";
	$band_path = "SiO/v2";
	$band_v = " v = 2";
	$band_txt = "*_Qv2_*MIZ.txt";
}
else{
	print " Failed!! \(ex. H2O => K, SiO=> Qv1 or Qv2 \)\n";
	die;
}


foreach my $file (@file_list){

	my $station;
	my $maepass;
	my $name;
	($maepass,$name) = split (/\/data\//, $file);


	# ディレクトリの有無の確認
	if( -e "$Ddat/$name/$band_path"){

	# $Ddat/$name/$band_path/$name-plot.txt があれば、$Ddat/$name/$band_path/$name-sort$band_sort.plt を完全に更新したいため最初に削除
	unlink "$Ddat/$name/$band_path/$name-plot.txt";

	# 天体ディレクトリの指定バンドのtxtファイルリストを抽出
	my @txtfile_list = glob("$Ddat/$name/$band_path/$band_txt");
	chomp @txtfile_list;

	# その抽出したリストから１つのテキストファイルを抽出
	foreach my $txtfile_and_pass (@txtfile_list){

		# 観測地を決める
		if(grep /IRK.txt/, $txtfile_and_pass){$station = "IRK";}
		elsif(grep /MIZ.txt/, $txtfile_and_pass){$station = "MIZ";}
		else{
			# mkpath は失敗すると、例外を発生させるので、eval{}; でキャッチ
			# 例外の内容は、$@ に格納されるので、 $@ をチェック。
			eval{mkpath "$Ddat/error_station";};
			if($@){die $@; }
			move "$txtfile_and_pass", "$Ddat/error_station" or die $!;
			print "ERROR: $txtfile_and_pass is failed!! This file was moved into $Ddat/error. \n";
		}

	# テキストファイルから作図に必要なpltファイル、観測日、強度のmax値、rms値を記録したファイルを作成するサブプロシージャーを実行
	# サブプロシージャーを実行後($pltfile_and_pass, $year, $month, $day)を代入する
		my $pltfile_and_pass;
		my $year;
		my $month;
		my $day;

		($pltfile_and_pass, $year, $month, $day) = &prepare_for_fig($Ddat, $name, $txtfile_and_pass, $band_path);

		# 返り値が4桁の数字以外のときはループの先頭に戻り、次に進む
#		next if ($year == 0);
		next if ($year !~ /[0-9]{4}/);

		my $date = join "", $year, $month, $day;
		my $date1 = join "/", $year, $month, $day;

		# 更新する天体毎に1観測のスペクトル図を作成するサブプロシージャーを実行
		&figure_spectra($Ddat, $name, $date, $pltfile_and_pass, $band_name, $band_path, $band_v, $date1);

	}


	# 天体毎に全てのスペクトル図リストを作成
	my @all_spectrum_list = glob("$Ddat/$name/$band_path/$name\_2*.png");
	my $all_spectrum_list1 = join "\n", @all_spectrum_list;

	open my $all_sp, ">", "$Ddat/$name/$band_path/$name\_allsp.lst"
	  or die "Cannot create '$name\_allsp.lst' in '$Ddat/$name/$band_path/' : $!";
	print $all_sp $all_spectrum_list1;
	close $all_sp;

	# 最新の観測結果のスペクトル図を$name-sp.pngにコピー
	my $n = @all_spectrum_list;
	$n = $n - 1;
	copy $all_spectrum_list[$n], "$Ddat/$name/$band_path/$name-sp.png" or die $!;


	# 天体毎に全ての観測リストを作成
	my @all_txt_list = glob("$Ddat/$name/$band_path/$name\_*$station.txt");
	my $all_txt_list1 = join "\n", @all_txt_list;

	open my $all_txt, ">", "$Ddat/$name/$band_path/$name\_alltxt.lst"
		  or die "Cannot create '$name\_alltxt.lst' in '$Ddat/$name/$band_path/' : $!";
	print $all_txt $all_txt_list1;
	close $all_txt;


	# $nameを@source_namesの最後に挿入
	push @source_names, "$name\t$band";


	}else{next;}

}

# 更新する天体名の配列の重複を削除
chomp @source_names;
my @source_names_1 = do { my %c; grep {!$c{$_}++} @source_names };
my $source_names_lst = join " ", @source_names_1;


# @source_namesの内容を$Dinp内にあるsource_names.lstに保存する
	open my $name_list, ">", "$Dinp/source_names.lst"
	  or die "Cannot create 'source_names.lst' in '$Dinp/' : $!";
	print $name_list $source_names_lst;
	close $name_list;









###########################################################
# 各観測ファイルの観測日とスペクトル値、最大強度の点を抜き出し、
# pltファイル、$name-plot.txt($name-sort.plt)を作成するサブプロシージャー
###########################################################

sub prepare_for_fig{

	# 引数の受け取り
	my $Ddat = $_[0];
	my $name = $_[1];
	my $file = $_[2];
	my $band_path = $_[3];

	my $a;
	my $b;
	my $c;
	my $d;
	my $e;
	my $f;
	my $g;
	my $ch;
	my $vlsr;
	my $int;
	my $year;
	my $month;
	my $day;
	my $rms;
	my $err;
	my $no = 10;
	my $max = 0;
	my $filesp = $file;
	$filesp =~ s/txt/plt/;	# txtファイル名からpltファイル名を作成

	# $fileを@lineに読み込む
	my $fh;
	open $fh, '<', "$file"
	 or die "Cannot open file '$file' : $!";
	my @line = <$fh>;
	close($fh);

#print "$file \n";
	my $gyosu = @line; 	# 配列の個数を取得

	# 一般的なファイルの行数が1282 or 1284 or 2306だから、ちょうどそれらファイルの行数の2、3、4倍のファイルは解析内容が2重、3重になってることがあるため、行数で調節
	my $Nline1 = 1282;
	my $Nline2 = 1284;
	my $Nline3 = 2306;

	if ($gyosu == $Nline1*2){ $gyosu = $gyosu / 2; }
	elsif ($gyosu == $Nline1*3){ $gyosu = $gyosu / 3; }
	elsif ($gyosu == $Nline1*4){ $gyosu = $gyosu / 4; }
	elsif ($gyosu == $Nline1*5){ $gyosu = $gyosu / 5; }
	elsif ($gyosu == $Nline1*6){ $gyosu = $gyosu / 6; }
	elsif ($gyosu == $Nline1*7){ $gyosu = $gyosu / 7; }
	elsif ($gyosu == $Nline1*8){ $gyosu = $gyosu / 8; }
	elsif ($gyosu == $Nline1*9){ $gyosu = $gyosu / 9; }
	elsif ($gyosu == $Nline1*10){ $gyosu = $gyosu / 10; }
	elsif ($gyosu == $Nline1*11){ $gyosu = $gyosu / 11; }
	elsif ($gyosu == $Nline1*12){ $gyosu = $gyosu / 12; }
	elsif ($gyosu == $Nline1*13){ $gyosu = $gyosu / 13; }
	elsif ($gyosu == $Nline1*14){ $gyosu = $gyosu / 14; }
	elsif ($gyosu == $Nline1*15){ $gyosu = $gyosu / 15; }

	elsif ($gyosu == $Nline2*2){ $gyosu = $gyosu / 2; }
	elsif ($gyosu == $Nline2*3){ $gyosu = $gyosu / 3; }
	elsif ($gyosu == $Nline2*4){ $gyosu = $gyosu / 4; }
	elsif ($gyosu == $Nline2*5){ $gyosu = $gyosu / 5; }
	elsif ($gyosu == $Nline2*6){ $gyosu = $gyosu / 6; }
	elsif ($gyosu == $Nline2*7){ $gyosu = $gyosu / 7; }
	elsif ($gyosu == $Nline2*8){ $gyosu = $gyosu / 8; }
	elsif ($gyosu == $Nline2*9){ $gyosu = $gyosu / 9; }
	elsif ($gyosu == $Nline2*10){ $gyosu = $gyosu / 10; }
	elsif ($gyosu == $Nline2*11){ $gyosu = $gyosu / 11; }
	elsif ($gyosu == $Nline2*12){ $gyosu = $gyosu / 12; }
	elsif ($gyosu == $Nline2*13){ $gyosu = $gyosu / 13; }
	elsif ($gyosu == $Nline2*14){ $gyosu = $gyosu / 14; }
	elsif ($gyosu == $Nline2*15){ $gyosu = $gyosu / 15; }

	elsif ($gyosu == $Nline3*2){ $gyosu = $gyosu / 2; }
	elsif ($gyosu == $Nline3*3){ $gyosu = $gyosu / 3; }
	elsif ($gyosu == $Nline3*4){ $gyosu = $gyosu / 4; }
	elsif ($gyosu == $Nline3*5){ $gyosu = $gyosu / 5; }
	elsif ($gyosu == $Nline3*6){ $gyosu = $gyosu / 6; }
	elsif ($gyosu == $Nline3*7){ $gyosu = $gyosu / 7; }
	elsif ($gyosu == $Nline3*8){ $gyosu = $gyosu / 8; }
	elsif ($gyosu == $Nline3*9){ $gyosu = $gyosu / 9; }
	elsif ($gyosu == $Nline3*10){ $gyosu = $gyosu / 10; }
	elsif ($gyosu == $Nline3*11){ $gyosu = $gyosu / 11; }
	elsif ($gyosu == $Nline3*12){ $gyosu = $gyosu / 12; }
	elsif ($gyosu == $Nline3*13){ $gyosu = $gyosu / 13; }
	elsif ($gyosu == $Nline3*14){ $gyosu = $gyosu / 14; }
	elsif ($gyosu == $Nline3*15){ $gyosu = $gyosu / 15; }

	$gyosu = $gyosu -1;	# 個数は1から始まるが行数は0から始まるため
	unlink "$filesp";	# $filesp があれば削除

	# judgment
	# 例外はeval{}; でキャッチし、内容は、$@ に格納されるので、$@をチェック
	# 視線速度が数字でないor絶対値で500を超える場合にはerrorフォルダを作成、格納
	# 視線速度がほぼ変動しない場合にもerrorフォルダを作成、格納

	eval {
		# 適当な行のVlsrの値
		my $vlsr1;
		my $vlsr2;
		($ch,$vlsr1,$int) = split (/\s+/, $line[1260]);
		if($vlsr1 =~ /\D{2,3}/ or abs($vlsr1) > 500){
			mkpath "$Dinp/error_Vlsr";
			if($@){die $@; }
			move "$file", "$Dinp/error_Vlsr/" or die $!;
			print "ERROR: $file is Vlsr failed!! This file was moved into $Dinp/error_Vlsr/. \n";
			die;
		}

		# 1回目の適当な行のVlsrの値
		($a,$ch,$vlsr1,$int) = split (/\s+/, $line[300]);

		# 行の最初にchの値があるとき
		if($a =~ /[0-9]/){($ch,$vlsr1,$int) = split (/\s+/, $line[300]);}

		# 2回目の適当な行のVlsrの値
		($a,$ch,$vlsr2,$int) = split (/\s+/, $line[1000]);

		# 行の最初にchの値があるとき
		if($a =~ /[0-9]/){($ch,$vlsr2,$int) = split (/\s+/, $line[1000]);}

		# 2つの適当な値を整数にする
		$vlsr1 = int($vlsr1);
		$vlsr2 = int($vlsr2);

		if($vlsr1 == $vlsr2){
			mkpath "$Dinp/error_Vlsr";
			if($@){die $@; }
			move "$file", "$Dinp/error_Vlsr/" or die $!;
			print "ERROR: $file is Vlsr failed!! This file was moved into $Dinp/error_Vlsr/. \n";
			die;
		}
	};

	if ($@){
		warn "ERROR: $@ \n";
		return (0, 0, 0, 0);
	}

	# Dateを抽出
	# year
	($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $line[11]);
	$year = $g;	

	# month
	($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $line[12]);
	if($g < 10) {$month = join('', 0, $g);}
	else {$month = $g;}
	
	# day
	($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $line[13]);
	if($g < 10) {$day = join('', 0, $g);}
	else {$day = $g;}

	open my $sp_list, ">>", "$filesp"
	  or die "Cannot create '$filesp': $!";
	print $sp_list "\#$year\/$month\/$day\n";
	close $sp_list;


	# spectrumの抽出
	# ファイルによって、259行目から解析結果がある場合と261行目からある場合があるので場合分けして出力
	($a,$ch,$vlsr,$int) = split (/\s+/, $line[258]);
	if($ch =~ /[0-9]/){
		# 最初と最後の方のchはエラーが含まれやすいので省く。
		# よって259行目から解析結果がある場合は、263 ~ $gyosu - 5
		for($no = 263; $no <= $gyosu - 5; $no++){
			($a,$ch,$vlsr,$int) = split (/\s+/, $line[$no]);

			# 行の最初にchの値があるとき
			if($a =~ /[0-9]/){
				($ch,$vlsr,$int) = split (/\s+/, $line[$no]);
			}

			# pltファイルに書き出す
			open $sp_list, ">>", "$filesp"
			  or die "Cannot create '$filesp': $!";
			print $sp_list "$vlsr\t$int\n";
			close $sp_list;
		}
	}else{
		# 261行目から最後の行まで → 265 ~ $gyosu - 5
		for($no = 265; $no <= $gyosu - 5; $no++){
			($a,$ch,$vlsr,$int) = split (/\s+/, $line[$no]);
			if($a =~ /[0-9]/){
				($ch,$vlsr,$int) = split (/\s+/, $line[$no]);
			}
			open $sp_list, ">>", "$filesp"
			  or die "Cannot create '$filesp': $!";
			print $sp_list "$vlsr\t$int\n";
			close $sp_list;
		}
	}

	# rmsを抽出
	($a,$b,$c,$d,$e,$f) = split (/\s+/, $line[231]);
	$rms = $f;

	# judgment
	# $err(rms)が0or50を超える場合にはerrorフォルダを作成、格納
	# 例外はeval{}; でキャッチし、内容は、$@ に格納されるので、$@をチェック
	eval {
		if($rms == 0 or $rms > 90){
			mkpath "$Dinp/error_rms";
			move "$file", "$Dinp/error_rms/" or die $!;
			unlink "$filesp";
		print "ERROR: $file is rms failed!! This file was moved into $Dinp/error_rms/. \n";
			die;
		}
	};
	if ($@) {
 		warn "ERROR: $@ \n";
		return (0, 0, 0, 0);
	}

	$err = $rms/2;


	# maxを抽出
	# 最大値は最初と最後からから2、3chにはほぼないので
	# 266行目から最後の行から10行前 → 265 ~ $gyosu -10 を指定

	my $gyosu1 = $gyosu - 10;
	for($no = 265; $no <= $gyosu1; $no++){
		($a,$ch,$vlsr,$int) = split (/\s+/, $line[$no]);
		if($a =~ /[0-9]/){
			($ch,$vlsr,$int) = split (/\s+/, $line[$no]);
		}
		if($max < $int){
			$max = $int;
#print $max,"\n";
		}
	}


	# ライトカーブを描くために必要なパラメーターを$name-plot.txtに追加書き込みし、それをソートした$name-sort$band_class.pltを作成

	my @lc_plt_list;

	# ファイルの有無の確認
	if( -e "$Ddat/$name/$band_path/$name-plot.txt"){
		open my $plt_list1, "<", "$Ddat/$name/$band_path/$name-plot.txt"
		  or die "Cannot open '$name-plot.txt' in '$Ddat/$name/$band_path/' : $!";
		@lc_plt_list = <$plt_list1>;
		close $plt_list1;
	}

	# judgment
	# 全く同じ観測のファイル(解析日が異なるだけの)の確認
	my $lc_parameter = "$year\/$month\/$day\t$max\t$err\n";
	if(grep /$lc_parameter/, @lc_plt_list){
		# mkpath は失敗すると、例外を発生させるので、eval{}; でキャッチ
		# 例外の内容は、$@ に格納されるので、 $@ をチェック。
		eval{mkpath "$Ddat/$name/$band_path/error_SameTime";};
		if($@){die $@; }
		move "$file", "$Ddat/$name/$band_path/error_SameTime/" or die $!;
		unlink "$filesp";
		print "ERROR: $file is date failed!! This file was moved into $Ddat/$name/$band_path/error_SameTime/. \n";
		return (0, 0, 0, 0);
	}

	# 配列に追加
	push @lc_plt_list, "$year\/$month\/$day\t$max\t$err\n";


	# $name-plot.txt内のパラメーター重複を削除
	my @lc_plt_list_1 = do { my %c; grep {!$c{$_}++} @lc_plt_list };

	open my $plt_list2, ">", "$Ddat/$name/$band_path/$name-plot.txt"
	  or die "Cannot create '$name-plot.txt' in '$Ddat/$name/$band_path/' : $!";
	print $plt_list2 @lc_plt_list_1;
	close $plt_list2;

	my $band_class;
	if($band_path =~ /H2O/){ $band_class = ""; }
	elsif($band_path =~ /SiO\/v1/){ $band_class = "v1"; }
	elsif($band_path =~ /SiO\/v2/){ $band_class = "v2"; }

	system("sort $Ddat/$name/$band_path/$name-plot.txt > $Ddat/$name/$band_path/$name-sort$band_class.plt");



	# pltファイルの形式を統一
#	open $sp_list, "<", "$filesp"
#	  or die "Cannot open '$filesp' : $!";
#	my @value = <$sp_list>;
#	close($sp_list);
#	if($value[3] =~ /^-/){
#		push(@value, $value[0]);
#		@value = reverse(@value);
#		open $sp_list, ">", "$filesp"
#		  or die "Cannot create '$filesp' : $!";
#		print $sp_list @value;
#		close $sp_list;
#		}

	return ($filesp, $year, $month, $day);

}









###########################################################
# 更新する天体毎に1観測のスペクトル図を作成するサブプロシージャー
###########################################################

sub figure_spectra {
	my $Ddat = $_[0];
	my $name = $_[1];
	my $date = $_[2];
	my $pltfile_and_path = $_[3];
	my $band_name = $_[4];
	my $band_path = $_[5];
	my $band_v = $_[6];
	my $date1 = $_[7];
	my $gnuplot = '/usr/local/bin/gnuplot -persist';


	# xrangeの設定パラメーター$xmax、$xminを取得
	my $xmin;
	my $xmax;
	my $int;

	my $fh;
	open $fh, '<', "$pltfile_and_path"
	 or die "Cannot open file '$pltfile_and_path' : $!";
	my @line = <$fh>;
	close($fh);

	my $gyosu = @line; 	# 配列の個数を取得
	$gyosu = $gyosu -1;
	($xmax,$int) = split(/\t/, $line[1]);
	($xmin,$int) = split(/\t/, $line[$gyosu-1]);


	my $k;
	my @plot;
	$plot[$k++] = sprintf("set terminal png font \"Times\" enhanced \n");
	$plot[$k++] = sprintf("set output '$Ddat/$name/$band_path/$name\_$date.png'\n");
	$plot[$k++] = sprintf("set title \"$band_name Maser's$band_v Spectrum of $date1.\"font\"Times,13\"\n");
	$plot[$k++] = sprintf("set xrange [$xmin:$xmax]\n");
#	$plot[$k++] = sprintf("set yrange [-0.3:*]\n");
	$plot[$k++] = sprintf("set xtics 25\n");
#	$plot[$k++] = sprintf("set ytics 0.5\n");
	$plot[$k++] = sprintf("set mxtics 5\n");
#	$plot[$k++] = sprintf("set mytics 2\n");
	$plot[$k++] = sprintf("set key outside right center\n");
	$plot[$k++] = sprintf("set xlabel \"LSR velocity [km s^\{-1\}]\" font\"Times,13\"\n");
	$plot[$k++] = sprintf("set ylabel \"Antenna temperature [K]\"font\"Times-Itaric,13\"\n");
	$plot[$k++] = sprintf("plot \"$pltfile_and_path\" u 1:2 ti \"\" w l linewidth 1.5 \n");
	$plot[$k++] = sprintf("set terminal x11\n");
	
	open(GNUPLOT,"| $gnuplot")
	 or die qq{Can't find any "gnuplot" in "$gnuplot" : $!};
	foreach $k (0..$#plot){print GNUPLOT $plot[$k];}
	close GNUPLOT;

}






# line 0: warning: Too many axis ticks requested (>4e+03)
# ↑ 上限を超えてしまっているときに表示される。
















###########################################################
###########################################################
#
# 天体毎のディレクトリ($Ddat/$name/$band_path/)の.pltファイルから図を作成
#
###########################################################
###########################################################


# 更新する天体毎にライトカーブ図を作成するサブプロシージャーを実行
&figure_light_curve($Dinp, $Ddat);


# 更新する天体毎に"Time series of maser spectra"の図を作成するサブプロシージャーを実行
&figure_time_series_spectra($Dinp, $Ddat);







###########################################################
# 更新する天体毎にライトカーブ図を作成するサブプロシージャー
###########################################################
	
sub figure_light_curve {

	my $Dinp = $_[0];
	my $Ddat = $_[1];
	my $gnuplot = '/usr/local/bin/gnuplot -persist';


	# 更新する天体名_バンドを列挙
	open my $name_list, "<", "$Dinp/source_names.lst"
	  or die "Cannot open 'source_names.lst' in '$Dinp/' : $!";
	my $new_source_name = <$name_list>;
	close $name_list;
	
	my @new_source_name1 = split / /, $new_source_name;
	
	foreach my $name_band (@new_source_name1){

		my $name;
		my $band;
		($name, $band) = split /\t/, $name_band;

#print "source name = $name \n band = $band \n";

		# バンドの種別
		my $band_name;
		my $band_path;
		my $band_v;
		my $band_plt;
		my $band_class;

		if($band =~ /K/i){
			$band_name = "H_\{2\}O";
			$band_path = "H2O";
			$band_v = "";
			$band_plt = "*_K_*IRK.plt";
			$band_class = "";
		}
		elsif($band =~ /Qv1/i){
			$band_name = "SiO";
			$band_path = "SiO/v1";
			$band_v = " v = 1";
			$band_plt = "*_Qv1_*MIZ.plt";
			$band_class = "v1";
		}
		elsif($band =~ /Qv2/i){
			$band_name = "SiO";
			$band_path = "SiO/v2";
			$band_v = " v = 2";
			$band_plt = "*_Qv2_*MIZ.plt";
			$band_class = "v2";
		}

		# ディレクトリの有無の確認
		if( -e "$Ddat/$name/$band_path"){

			my $k;
			my @plot;
			my $a = 'set timefmt "%Y/%m/%d";';
			my $b = 'set format x "%y/%m";';

			$plot[$k++] = sprintf("set terminal png font \"Times\" enhanced \n");
			$plot[$k++] = sprintf("set output '$Ddat/$name/$band_path/$name-lc$band_class.png'\n");
			$plot[$k++] = sprintf("set title \"$band_name Maser's$band_v Light Curve.\" font\"Times,13\"\n");
			$plot[$k++] = sprintf("set key outside right center\n");
			$plot[$k++] = sprintf("set xdata time\n");
			$plot[$k++] = $a;
#			$plot[$k++] = sprintf("set timefmt \"%Y\/%m\/%d\"\n");
			$plot[$k++] = sprintf("set xlabel \"Date[YY/MM]\" font\"Times,13\"\n");
#			$plot[$k++] = sprintf("set format x \"%y\/%m\"\n");
			$plot[$k++] = sprintf("set autoscale xfixmin\n");
			$plot[$k++] = sprintf("set autoscale xfixmax\n");
			$plot[$k++] = sprintf("set mxtics 2\n");
			$plot[$k++] = $b;
			$plot[$k++] = sprintf("set ylabel \"Antenna temperature [K]\"font\"Times-Itaric,13\"\n");
			$plot[$k++] = sprintf("plot \"$Ddat/$name/$band_path/$name-sort$band_class.plt\" u 1:2 ti \"\" with linespoints linewidth 1.5, \"$Ddat/$name/$band_path/$name-sort$band_class.plt\" u 1:2:3 ti \"\" with yerrorbars linewidth 1.5 \n");
			$plot[$k++] = sprintf("set terminal x11\n");
	
			open(GNUPLOT,"| $gnuplot")
			 or die qq{Can't find any "gnuplot" in "$gnuplot" : $!};
			foreach $k (0..$#plot){print GNUPLOT $plot[$k];}
			close GNUPLOT;



			# SiOメーザーの時は二つのライトカーブを示した図を作成
			if($band !~ /K/i){

				my $band_path1 = "SiO/v1";
				my $band_class1 = "v1";
				my $band_path2 = "SiO/v2";
				my $band_class2 = "v2";

				$plot[$k++] = sprintf("set terminal png font \"Times\" enhanced \n");
				$plot[$k++] = sprintf("set output '$Ddat/$name/SiO/$name-lc_SiO.png'\n");
				$plot[$k++] = sprintf("set title \"SiO Maser's Light Curve.\" font\"Times,13\"\n");
				$plot[$k++] = sprintf("set key outside right center\n");
				$plot[$k++] = sprintf("set xdata time\n");
				$plot[$k++] = $a;
#				$plot[$k++] = sprintf("set timefmt \"%Y\/%m\/%d\"\n");
				$plot[$k++] = sprintf("set xlabel \"time[YY/MM]\" font\"Times,13\"\n");
#				$plot[$k++] = sprintf("set format x \"%y\/%m\"\n");
				$plot[$k++] = sprintf("set autoscale xfixmin\n");
				$plot[$k++] = sprintf("set autoscale xfixmax\n");
				$plot[$k++] = sprintf("set mxtics 2\n");
				$plot[$k++] = $b;
				$plot[$k++] = sprintf("set ylabel \"Antenna temperature [K]\"font\"Times-Itaric,13\"\n");
				$plot[$k++] = sprintf("plot \"$Ddat/$name/$band_path1/$name-sort$band_class1.plt\" u 1:2 ti \"\" with linespoints linewidth 1.5, \"$Ddat/$name/$band_path1/$name-sort$band_class1.plt\" u 1:2:3 ti \"v1\" with yerrorbars linewidth 1.5, \"$Ddat/$name/$band_path2/$name-sort$band_class2.plt\" u 1:2 ti \"\" with linespoints linewidth 1.5, \"$Ddat/$name/$band_path2/$name-sort$band_class2.plt\" u 1:2:3 ti \"v2\" with yerrorbars linewidth 1.5 \n");
				$plot[$k++] = sprintf("set terminal x11\n");
	
				open(GNUPLOT,"| $gnuplot")
				 or die qq{Can't find any "gnuplot" in "$gnuplot" : $!};
				foreach $k (0..$#plot){print GNUPLOT $plot[$k];}
				close GNUPLOT;
			}



			# H2OとSiOのライトカーブを示した図を作成
			$band_path = "H2O";
			$band_class = "";
			my $band_path1 = "SiO/v1";
			my $band_class1 = "v1";
			my $band_path2 = "SiO/v2";
			my $band_class2 = "v2";
#			my $name_sort = join ($name, "-sort);

			if( -e "$Ddat/$name/$band_path1/$name-sort$band_class1.plt" and -e "$Ddat/$name/$band_path2/$name-sort$band_class2.plt"){
			$plot[$k++] = sprintf("reset\n");
			$plot[$k++] = sprintf("set terminal postscript font \"Times\" eps enhanced solid \n");
			$plot[$k++] = sprintf("set output '$Ddat/$name/$name-all_lc.eps'\n");
			$plot[$k++] = sprintf("set title \"SiO and H_\{2\}O Maser's Light Curve.\" font\"Times,13\"\n");
			$plot[$k++] = sprintf("set key outside right center\n");
			$plot[$k++] = sprintf("set xdata time\n");
			$plot[$k++] = $a;
			$plot[$k++] = sprintf("set xlabel \"Date[YY/MM]\" font\"Times,13\"\n");
#			$plot[$k++] = sprintf("set autoscale xfixmin\n");
			$plot[$k++] = sprintf("set autoscale x\n");
			$plot[$k++] = sprintf("set mxtics 2\n");
			$plot[$k++] = $b;
			$plot[$k++] = sprintf("set y2label \"H_\{2\}O Antenna temperature [K]\"font\"Times-Itaric,13\"\n");
			$plot[$k++] = sprintf("set ylabel \"SiO Antenna temperature [K]\"font\"Times-Itaric,13\"\n");
			$plot[$k++] = sprintf("set y2tics border\n");
			$plot[$k++] = sprintf("set mytics 2\n");
			$plot[$k++] = sprintf("set my2tics 2\n");
#			$plot[$k++] = sprintf("set autoscale y2\n");
#			$plot[$k++] = sprintf("set autoscale y\n");
#			$plot[$k++] = sprintf("set autoscale fix\n");
			$plot[$k++] = sprintf("set ytics nomirror\n");
			$plot[$k++] = sprintf("set style line 1 linecolor rgbcolor \"#000000\" lw 4 linetype 1\n");
			$plot[$k++] = sprintf("set style line 2 linecolor rgbcolor \"#5C5C5C\" lw 6 linetype 2\n");
			$plot[$k++] = sprintf("set style line 3 linecolor rgbcolor \"#878787\" lw 6 linetype 1\n");
			$plot[$k++] = sprintf("plot \"$Ddat/$name/$band_path/$name-sort$band_class.plt\" u 1:2 ti \"\" with linespoints ls 1 axis x1y2, \"$Ddat/$name/$band_path/$name-sort$band_class.plt\" u 1:2:3 ti \"H_\{2\}O\" with yerrorbars ls 1 axis x1y2, \"$Ddat/$name/$band_path1/$name-sort$band_class1.plt\" u 1:2 ti \"\" with linespoints ls 2 axis x1y1, \"$Ddat/$name/$band_path1/$name-sort$band_class1.plt\" u 1:2:3 ti \"SiO v=1\" with yerrorbars ls 2 axis x1y1, \"$Ddat/$name/$band_path2/$name-sort$band_class2.plt\" u 1:2 ti \"\" with linespoints ls 3 axis x1y1, \"$Ddat/$name/$band_path2/$name-sort$band_class2.plt\" u 1:2:3 ti \"SiO v=2\" with yerrorbars  ls 3  axis x1y1\n");
			$plot[$k++] = sprintf("set terminal x11\n");
	
			open(GNUPLOT,"| $gnuplot")
			 or die qq{Can't find any "gnuplot" in "$gnuplot" : $!};
			foreach $k (0..$#plot){print GNUPLOT $plot[$k];}
			close GNUPLOT;

			}
		}
	}
}




# Warning: empty x range[...], adjusting to [...]
# ↑gnuplotはデフォルトでは1e-08より小さい全ての数を0として扱います。
# set zero <expression> (例 set zero 1e-20)と対策すれば良い










###########################################################
# 更新する天体毎に"Time series of maser spectra"の図
# を作成するサブプロシージャー
###########################################################

sub figure_time_series_spectra {

	my $Dinp = $_[0];
	my $Ddat = $_[1];
	my $gnuplot = '/usr/local/bin/gnuplot -persist';


	# 更新する天体名_バンドを列挙
	open my $name_list, "<", "$Dinp/source_names.lst"
	  or die "Cannot open 'source_names.lst' in '$Dinp/' : $!";
	my $new_source_name = <$name_list>;
	close $name_list;
	
	my @new_source_name1 = split / /, $new_source_name;
	
	foreach my $name_band (@new_source_name1){

		my $name;
		my $band;
		($name, $band) = split /\t/, $name_band;

print "source name = $name\n";
		# バンドの種別
		my $band_name;
		my $band_path;
		my $band_v;
		my $band_plt;
		my $band_class;

		if($band =~ /K/i){
			$band_name = "H_\{2\}O";
			$band_path = "H2O";
			$band_v = "";
			$band_plt = "*_K_*IRK.plt";
			$band_class = "";
		}
		elsif($band =~ /Qv1/i){
			$band_name = "SiO";
			$band_path = "SiO/v1";
			$band_v = " v = 1";
			$band_plt = "*_Qv1_*MIZ.plt";
			$band_class = "v1";
		}
		elsif($band =~ /Qv2/i){
			$band_name = "SiO";
			$band_path = "SiO/v2";
			$band_v = " v = 2";
			$band_plt = "*_Qv2_*MIZ.plt";
			$band_class = "v2";
		}

		# ディレクトリの有無の確認
		if( -e "$Ddat/$name/$band_path"){
	
			# $Ddat/$name/$band_path/内のpltファイルを列挙
#			my @pltfiles = glob("$Ddat/$name/$band_path/$band_plt") or die;
			my @pltfiles = glob("$Ddat/$name/$band_path/$band_plt") or next;
			chomp @pltfiles;


			my $pltfiles_num = @pltfiles; 	# 配列の個数を取得
			my $i = 0;
			my $date;
			my $GP1 = "'";
			my $GP2 = "' using 1:(\$2+";
			my $GP3 = ") title '";
			my $GP4 = "' with linespoints linewidth 2.5 pointtype 0, \\\n";
			my $GP5 = "' with linespoints linewidth 2.5 pointtype 0\n";
			my $GP6 = "' with linespoints ";
			my $GP7 = "pointtype 0, \\\n";
			my $GP8 = "' with linespoints ";
			my $GP9 = "pointtype 0\n";

			my @plus_value;
			my @supectrum_plot;
			my @supectrum_plot2;
			my @all_xrange8;	#xrangeを決める配列を定義
			my @all_xrange10;	#xrangeを決める配列を定義


			# $name-sort$band_class.plt内の情報を読み取る
			open my $plt_sort, '<', "$Ddat/$name/$band_path/$name-sort$band_class.plt"
			 or die "Cannot open file '$name-sort$band_class.plt' in '$Ddat/$name/$band_path/' : $!";
			my @info = <$plt_sort>;
			close($plt_sort);

	
			# pltfiles_numは0から始まるため以下のようにwhileを使用
			while ($i <  $pltfiles_num){

#print "Time-file = $pltfiles[$i] \n";

				open my $plt, "<", $pltfiles[$i]
				  or die "Cannot open '$pltfiles[$i]' : $!";
				my @line = <$plt>;
				chomp @line;
				close($plt);

				# ここでpltファイル内にある観測日を抜き出す
				$date = $line[0];
				$date =~ s/#//;
				chomp $date;

				# rmsの10倍のスペクトルの速度を抜き出す
				my @error_a = $info[$i];
				my @error_b = split /\t/, $error_a[0];
				my $error = $error_b[2];

				# 抜き出した値はrmsを半分にした値だから0.035以下の値の場合、抜き出す
				if ($error < 0.035){
					# rmsの8倍と10倍を抜き出すから16と20倍にする
					my $rms8 = $error * 16;
					my $rms10 = $error * 20;

					my $gyosu = @line; 	# 配列の個数を取得
					$gyosu = $gyosu -1;	# 個数は1から始まるが行数は0から始まるため
					# 最初と最後の方にはエラーが多いので15 ~ $gyosu -15 を指定
					my $gyosu1 = $gyosu - 15;
					my $no;
					for($no = 15; $no <= $gyosu1; $no++){
						my $a;
						my $ch;
						my $vlsr;
						my $int;
						($vlsr,$int) = split (/\t+/, $line[$no]);
						if(abs($vlsr) < 100){
							if($rms10 < $int){
								push @all_xrange10, "$vlsr";	# 配列に追加
							}
							if($rms8 < $int){
								push @all_xrange8, "$vlsr";	# 配列に追加
							}
						}
					}
				}


#				my @line;
#				while (@line = <$plt_list>) {
#					chomp @line;
#				# ここでpltファイル内にある観測日を抜き出す
#					$date = $line[0];
#					$date =~ s/#//;
#					}
#				close $plt_list;



				# 読み込んだファイルの1つ古い観測の観測日におけるスペクトルの最大値を読み込む
				my $j = $i - 1;
				if ($i == 0){$j = $i;}
				my @select = $info[$j];
				my @select_1 = split /\t/, $select[0];
				my $max_value = $select_1[1];

				# 読み込んだファイルの観測日からスペクトルの最大値を読み込む
#				my @select = grep(/$date/, @info);
#				print "@select";
#				my @select_1 = split /\t/, $select[0];
#				print "$select_1[1]\n";
#				my $max_value = $select_1[1];

				# $max_valueの値によりオフセットに加わる値を変える
				my $plus;
				if($i > 0){
					if($max_value >= 10){$plus = 10.5 ;}
#					elsif($max_value >= 1){$plus = 0.5 + int($max_value);}
					elsif($max_value >= 1){$plus = int($max_value);}
					else{$plus = 0.5;}
				}else{$plus = 0;}

#print "plus = $plus\n";


				# @plus_valueに$plusの値を最後尾に入れる
				push @plus_value, $plus;
#print "plus_value = @plus_value\n";


				# @plus_valueの値を全て足して合計する
				my $offset;
				foreach(@plus_value){$offset += $_;}
#print "offset = $offset\n";

				# style lineの値を決める
				my $lt_val = $i - int($i/5) * 5 +1;
				my $lt = " ls $lt_val ";


				# gnuplotで行なうplotの内容を@supectrum_plotに追加出力する
				my $GP_plt = join ('', $GP1, $pltfiles[$i], $GP2, $offset, $GP3, $date, $GP4);
				push @supectrum_plot, $GP_plt;

				my $GP_plt2 = join ('', $GP1, $pltfiles[$i], $GP2, $offset, $GP3, $date, $GP6, $lt, $GP7);
				push @supectrum_plot2, $GP_plt2;

				$i++;

			}

			# @supectrum_plotの先頭を削除
			shift @supectrum_plot;
			shift @supectrum_plot2;

			# @supectrum_plotの配列を逆にする
			@supectrum_plot = reverse(@supectrum_plot);
			@supectrum_plot2 = reverse(@supectrum_plot2);
	
			# それぞれの1番古い観測のpltファイル内にある観測日を抜き出し、gnuplotで行なうset plotの内容を@supectrum_plotに追加出力する

			open my $plt_list1, "<", $pltfiles[0]
			  or die "Cannot open '$pltfiles[0]' : $!";
			my @line;
			while (@line = <$plt_list1>) {
				chomp @line;
				$date = $line[0];
				$date =~ s/#//;
			}
			close($plt_list1);


			# style lineの値を決める
			my $lt_val = 1;
			my $lt = " ls $lt_val ";


			my $GP_plt = join ('', $GP1, $pltfiles[0], $GP2, 0.5*0, $GP3, $date, $GP5);
			push @supectrum_plot, $GP_plt;

			my $GP_plt2 = join ('', $GP1, $pltfiles[0], $GP2, 0.5*0, $GP3, $date, $GP8, $lt, $GP9);
			push @supectrum_plot2, $GP_plt2;


			# x軸の範囲設定

			# 数値昇順でソート
			my @all_xrange_sort8 = sort { $a <=> $b } @all_xrange8;
			my @all_xrange_sort10 = sort { $a <=> $b } @all_xrange10;

			my $gyosu = @all_xrange_sort10; 	# 配列の個数を取得
			my $xmax;
			my $xmin;

			# $rms10 < $int がある場合
			if ($gyosu > 0){
				# x軸の最小値を抜き出す
				my $xmin1 = $all_xrange_sort10[0];
				$xmin = $xmin1 -15;

				# x軸の最大値を抜き出す
				$gyosu = $gyosu -1;
				my $xmax1 = $all_xrange_sort10[$gyosu];
				$xmax = $xmax1 +15;
			# $rms10 < $int がない場合
			}elsif ($gyosu > 0){
				# x軸の最小値を抜き出す
				my $xmin1 = $all_xrange_sort8[0];
				$xmin = $xmin1 -15;
				# x軸の最大値を抜き出す
				$gyosu = @all_xrange_sort8; 	# 配列の個数を取得
				$gyosu = $gyosu -1;
				my $xmax1 = $all_xrange_sort8[$gyosu];
				$xmax = $xmax1 +15;
			# $rms10 < $int, $rms8 < $int がない場合
			}else{
				open my $plt_list, "<", $pltfiles[$pltfiles_num-1]
				  or die "Cannot open '$pltfiles[$pltfiles_num-1]' : $!";
				while (@line = <$plt_list>) {
					chomp @line;
					my $gyosu = @line; 	# 配列の個数を取得
					$gyosu = $gyosu -1;
					my $int;
					($xmax,$int) = split(/\t/, $line[1]);
					($xmin,$int) = split(/\t/, $line[$gyosu-1]);
				}
				close $plt_list;
			}

			# $max-$min < 40 の場合
			if ($xmax - $xmin <= 40){
				$xmax = $xmax + 10;
				$xmin = $xmin - 10;
			}


			#　gnuplotによる"Time series of maser spectra"の図の作成
			my $k;
			my @plot;

			$plot[$k++] = sprintf("reset\n");
			$plot[$k++] = sprintf("set terminal png size 1280,960 font\"Times\" enhanced \n");
			$plot[$k++] = sprintf("set output '$Ddat/$name/$band_path/$name\-time_sp$band_class.png'\n");
			$plot[$k++] = sprintf("set title \"Time series of $band_name maser$band_v spectra of $name.\" font\"Times,25\"\n");
			$plot[$k++] = sprintf("set xrange [$xmin:$xmax]\n");
			$plot[$k++] = sprintf("set yrange [-0.5:*]\n");
#			$plot[$k++] = sprintf("set xtics 25\n");
#			$plot[$k++] = sprintf("set ytics 4\n");
#			$plot[$k++] = sprintf("set mxtics 5\n");
			$plot[$k++] = sprintf("set mxtics 2\n");
#			$plot[$k++] = sprintf("set mytics 4\n");
			$plot[$k++] = sprintf("set grid xtics mxtics\n");
			$plot[$k++] = sprintf("set key outside right center vertical\n");
			$plot[$k++] = sprintf("set xlabel \"LSR velocity [km s^\{-1\}]\" \n");
			$plot[$k++] = sprintf("set ylabel \"Antenna temperature [K]\" \n");
#			$plot[$k++] = sprintf("set ylabel \"{/Times-Itaric=25 Antenna temperature [K]}\"\n");
			$plot[$k++] = sprintf("plot @supectrum_plot\n");
			$plot[$k++] = sprintf("set terminal x11\n");
	
			open(GNUPLOT,"| $gnuplot")
			 or die qq{Can't find any "gnuplot" in "$gnuplot" : $!};
			foreach $k (0..$#plot){print GNUPLOT $plot[$k];}
			close GNUPLOT;
	


			$plot[$k++] = sprintf("reset\n");
			$plot[$k++] = sprintf("set terminal postscript font \"Times\" eps enhanced solid \n");
			$plot[$k++] = sprintf("set output '$Ddat/$name/$band_path/$name\-time_sp$band_class.eps'\n");
			$plot[$k++] = sprintf("set lmargin 7\n");
			$plot[$k++] = sprintf("set bmargin 3\n");
			$plot[$k++] = sprintf("set rmargin 40\n");
			$plot[$k++] = sprintf("set tmargin 1\n");
			$plot[$k++] = sprintf("set xrange [$xmin:$xmax]\n");
			$plot[$k++] = sprintf("set yrange [-0.5:*]\n");
			$plot[$k++] = sprintf("set xtics offset 0.0,graph 0.01\n");
			$plot[$k++] = sprintf("set ytics offset graph 0.01,0\n");
#			$plot[$k++] = sprintf("set mxtics 5\n");
			$plot[$k++] = sprintf("set mxtics 2\n");
#			$plot[$k++] = sprintf("set mytics 4\n");
			$plot[$k++] = sprintf("set grid xtics mxtics\n");
			$plot[$k++] = sprintf("set mytics 2\n");
			$plot[$k++] = sprintf("set key outside right center font \"Times,13\" spacing 0.8 vertical\n");
			$plot[$k++] = sprintf("set xlabel \"LSR velocity [km s^\{-1\}]\" offset 0.0, 0.4 \n");
			$plot[$k++] = sprintf("set ylabel \"Antenna temperature [K]\" offset 1.0, 0.0 \n");
			$plot[$k++] = sprintf("set style line 1 linecolor rgbcolor \"#000000\" lw 2\n");
			$plot[$k++] = sprintf("set style line 2 linecolor rgbcolor \"#616161\" lw 2\n");
			$plot[$k++] = sprintf("set style line 3 linecolor rgbcolor \"#A3A3A3\" lw 2\n");
			$plot[$k++] = sprintf("set style line 4 linecolor rgbcolor \"#BFBFBF\" lw 3\n");
			$plot[$k++] = sprintf("set style line 5 linecolor rgbcolor \"#DBDBDB\" lw 3\n");
			$plot[$k++] = sprintf("plot @supectrum_plot2\n");
			$plot[$k++] = sprintf("set terminal x11\n");
	
			open(GNUPLOT,"| $gnuplot")
			 or die qq{Can't find any "gnuplot" in "$gnuplot" : $!};
			foreach $k (0..$#plot){print GNUPLOT $plot[$k];}
			close GNUPLOT;

		}else{next;}

	}
	
}
	





# 引数が存在しなかった場合にプログラムを終了するサブプロシージャー
sub error_scalar{
	my $scalar = $_[0];
#	print "$scalar\n";
	# 引数が存在しなかった場合にプログラムを終了
	$scalar = shift;
	die "$!" unless $scalar;
}



# 引数が数字でない場合にプログラムを終了するサブプロシージャー
sub error_num{

	# 受け取った引数を連結
	my $scalar = join '', @_;
#	print "$scalar\n";

	# 変数が数字でない場合にプログラムを終了
	die "$!" unless($scalar =~ /\d/);
#	\d = [0-9]

	# 上のコードと同じ
#	unless ($scalar =~ /\d/) {
#		die "$!";
#	}

}
