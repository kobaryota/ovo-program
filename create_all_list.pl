#!/usr/bin/perl

use strict;
use warnings;



###########################################################
###########################################################
#
#SouceList.lst、NameList.lst、allrename.txt、の中身を観測ファイルから作成する
#
###########################################################
###########################################################

# データファイルを列挙


# SourceList-draft.txtを削除
unlink "./SourceList-draft.txt";
unlink "./NameList-draft.txt";
unlink "./allrename-draft.txt";


my @source_files = glob("./*IRK.txt");
chomp @source_files;

&error_scalar(@source_files);


# それぞれのデータファイルに対し操作を行う
foreach my $file (@source_files){

	# $file内の情報を読み取る
	open my $file_list, '<', "$file"
	 or die "Cannot open file '$file' : $!";
	my @info = <$file_list>;
	close($file_list);


	# R.A.
	my @ra_info = split (/\s+/, $info[50]);

	my @ra_h0 = grep /h/, @ra_info;
	my $ra_h;
	($ra_h,$_) = split (/h/, $ra_h0[0]);
	if($ra_h < 10) {$ra_h = join('', 0, $ra_h);}

	my @ra_m0 = grep /m/, @ra_info;
	my $ra_m;
	($ra_m,$_) = split (/m/, $ra_m0[0]);
	if($ra_m < 10) {$ra_m = join('', 0, $ra_m);}

	my @ra_s0 = grep /s/, @ra_info;
	my $ra_s;
	($ra_s,$_) = split (/s/, $ra_s0[0]);

#	print "ra_h=$ra_h,ra_m=$ra_m,ra_s=$ra_s\n";
	my $ra = "$ra_h $ra_m $ra_s";
	&error_num($ra_h,$ra_m,$ra_s);


	# Decl.
	my @decl_info = split (/\s+/, $info[52]);

	my @decl_d0 = grep /d/, @decl_info;
	my $decl_d;
	($decl_d,$_) = split (/d/, $decl_d0[0]);
	if($decl_d >= 0 and $decl_d < 10) {
		($_,$decl_d) = split (/\+/, $decl_d);
		$decl_d = join('', "+0", $decl_d);
	}
	if(-10 < $decl_d and $decl_d < 0){
		($_,$decl_d) = split (/-/, $decl_d);
		$decl_d = join('', "-0", $decl_d);
	}

	my @decl_m0 = grep /'/, @decl_info;
	my $decl_m;
	($decl_m,$_) = split (/'/, $decl_m0[0]);
	if($decl_m < 10) {$decl_m = join('', 0, $decl_m);}

	my @decl_s0 = grep /"/, @decl_info;
	my $decl_s;
	($decl_s,$_) = split (/"/, $decl_s0[0]);

	my $decl = "$decl_d $decl_m $decl_s";
	&error_num($decl_d,$decl_m,$decl_s);


	# object name
	my $a;
	my $b;
	my $c;
	my $d;
	my $e;
	my $f;
	my $g;
	my $object_name;

	($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $info[220]);
	if($g =~ /[A-Z]/){
		$object_name = $g;
		&error_scalar($object_name);
	}elsif($f =~ /[A-Z]/){
		$object_name = $f;
		&error_scalar($object_name);
		($_,$object_name) = split (/=/, $object_name);
	}

	my $object_name1;
	if($object_name =~ /IRAS/){
		$a = substr $object_name, 4;
		$object_name1 = "IRAS $a";
	}elsif($object_name =~ /-\d/){
		my @split = split (m/-/, $object_name);
		$object_name1 = join " -", @split;
	}elsif($object_name =~ /-\D/){
		my @split = split (m/-/, $object_name);
		$object_name1 = join " ", @split;
	}else{
		$object_name1 = $object_name;
	}


	my $object_name2;
	if($object_name =~ /IRAS/){
		$a = substr $object_name, 4;
		$object_name2 = "IRAS_$a";
	}elsif($object_name =~ /-\d/){
		my @split = split (m/-/, $object_name);
		$object_name2 = join "-", @split;
	}elsif($object_name =~ /-\D/){
		my @split = split (m/-/, $object_name);
		$object_name2 = join "_", @split;
	}else{
		$object_name2 = $object_name;
	}

	

	# SouceList.lstの中身を作成する
	open my $fh, ">>", "./SourceList-draft.txt"
	  or die "Cannot create 'SourceList-draft.txt': $!";
	if($object_name =~ /IRAS/){
		print $fh "$object_name $object_name2 $ra $decl ?\n";
	}else{
		print $fh "$object_name2 $object_name $ra $decl ?\n";
	}
	close $fh;


	# NameList.lstの中身を観測ファイルから作成する
	open my $fh1, ">>", "./NameList-draft.txt"
	  or die "Cannot create 'NameList-draft.txt': $!";
	if($object_name =~ /IRAS/){
		print $fh1 "$object_name	$object_name1, \n";
	}else{
		print $fh1 "$object_name2	$object_name1, \n";
	}
	close $fh1;


	# allrename.txt、の中身を観測ファイルから作成する
	open my $fh2, ">>", "./allrename-draft.txt"
	  or die "Cannot create 'allrename-draft.txt': $!";
	if($object_name =~ /IRAS/){
		print $fh2 "$object_name, $object_name, \n";
	}else{
		print $fh2 "$object_name2, $object_name, \n";
	}
	close $fh2;

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

