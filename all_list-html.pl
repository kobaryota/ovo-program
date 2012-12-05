#!/usr/bin/perl

use strict;
use warnings;

my $Dinp = "/Users/sio/ovo/OVO/inputbox";
my $Ddat = "/Users/sio/Desktop/data";
my $Dlist = "/Users/sio/ovo/OVO/list";
my $Dhtml = "/Users/sio/Desktop/data";


# 更新した天体名_バンドを列挙
open my $name_list, "<", "$Dinp/source_names.lst"
  or die "Cannot open 'source_names.lst' in '$Dinp/' : $!";
my $new_source_name = <$name_list>;
close $name_list;


my $band_name;
my $band_path;
my $band;

# バンドの判別
if($new_source_name =~ /K/i){
	$band_name = "H2O";
	$band_path = "H2O";
	$band = "K";

	# ファイルの有無の確認
	if( -e "$Dhtml/maserlist-$band.txt"){
		&maser_list($Ddat, $Dlist, $Dhtml, $band_name, $band_path, $new_source_name);
	}else{
		&all_maser_list($Ddat, $Dlist, $Dhtml, $band_name, $band_path);

	}


}elsif($new_source_name =~ /Qv1/i){
	$band_name = "SiO";
	$band_path = "SiO/v1";
	$band = "Q";

	# ファイルの有無の確認
	if( -e "$Dhtml/maserlist-$band.txt"){
		&maser_list($Ddat, $Dlist, $Dhtml, $band_name, $band_path, $new_source_name);
	}else{
		&all_maser_list($Ddat, $Dlist, $Dhtml, $band_name, $band_path);
	}


}elsif($new_source_name =~ /Qv2/i){
	$band_name = "SiO";
	$band_path = "SiO/v2";
	$band = "Q";

	# ファイルの有無の確認
	if( -e "$Dhtml/maserlist-$band.txt"){
		&maser_list($Ddat, $Dlist, $Dhtml, $band_name, $band_path, $new_source_name);
	}else{
		&all_maser_list($Ddat, $Dlist, $Dhtml, $band_name, $band_path);
	}


}









#sub preparre_for_maser_list{



sub all_maser_list{

	my $Ddat = $_[0];
	my $Dlist = $_[1];
	my $Dhtml = $_[2];
	my $band_name = $_[3];
	my $band_path = $_[4];
	my @all_source_val;

	open my $list, "<", "$Dlist/SourceList.txt";
	my @basic = <$list>;
	chomp @basic;
	close $list;

	foreach my $basic (@basic){

		my $name1;
		my $name2;
		my $coordinate_h;
		my $coordinate_m;
		my $coordinate_s;
		my $coordinate_d;
		my $coordinate_m2;
		my $coordinate_s2;
		my $system_velocity;

		($name1, $name2, $coordinate_h, $coordinate_m, $coordinate_s, $coordinate_d, $coordinate_m2, $coordinate_s2, $system_velocity) = split (/\s+/, $basic);
#		my $name25 = $name2;
		my $name25 = $name1;

		if($name25 =~ /IRAS/){
#			$name25 =~ s/\+/\\\+/;
			substr($name25, 4, 0) = " ";
		}

		open my $plt_files, "<", "$Ddat/$name1/$band_path/$name1-sort.plt" or next;
		my @sort_plt = <$plt_files>;
		chomp @sort_plt;
		close $plt_files;

		my $date;
		my $peak;
		my $rms;
		my $detect;
		my $n = @sort_plt;
		$n = $n - 1;
		($date, $peak, $rms) = split (/\t+/, $sort_plt[$n]);
		my $sigma = $peak/$rms/2;
		my $flux =sprintf("%.2f", $peak*20);
		$sigma = sprintf("%.1f", $sigma);

		if($sigma >= 5){
			$detect = "Yes!($sigma)";
		}else{
			$detect = "No($sigma)";
		}

		my @source_val = join (' ', $name1, $name2, $coordinate_h, $coordinate_m, $coordinate_s, $coordinate_d, $coordinate_m2, $coordinate_s2, $system_velocity, $date, $flux, $detect, "\n");
		push @all_source_val, @source_val;

	}

	open my $maser_list, ">", "$Dhtml/maserlist-$band_name.txt"
	  or die "Cannot create 'maserlist-$band_name.txt' : $!";
	print $maser_list @all_source_val;
	close $maser_list;
}






sub maser_list{

	my $Ddat = $_[0];
	my $Dlist = $_[1];
	my $Dhtml = $_[2];
	my $band_name = $_[3];
	my $band_path = $_[4];
	my $new_source_name = $_[5];

	my @all_source_val;
	my @new_source_name1 = split / /, $new_source_name;


	open my $list, "<", "$Dlist/SourceList.txt";
	my @basic = <$list>;
	chomp @basic;
	close $list;

	
	foreach my $name_band (@new_source_name1){

		my $name;
		my $band;
		($name, $band) = split /\t/, $name_band;


$name =~ s/\+|-/\./ if $name =~ /\+|\-/;
#($name,$_) = split /\+|\-/, $name if $name =~ /\+|\-/;

#print "grep(/$name/)\n";

		my @target_line = grep(/$name/, @basic);

print "$target_line[0]\n";
		my $name1;
		my $name2;
		my $coordinate_h;
		my $coordinate_m;
		my $coordinate_s;
		my $coordinate_d;
		my $coordinate_m2;
		my $coordinate_s2;
		my $system_velocity;

		($name1, $name2, $coordinate_h, $coordinate_m, $coordinate_s, $coordinate_d, $coordinate_m2, $coordinate_s2, $system_velocity) = split (/\s+/, $target_line[0]);
#		my $name25 = $name2;
		my $name25 = $name1;

		if($name25 =~ /IRAS/){
#			$name25 =~ s/\+/\\\+/;
			substr($name25, 4, 0) = " ";
		}


#print "$name1, $name2, $coordinate_h, $coordinate_m, $coordinate_s, $coordinate_d, $coordinate_m2, $coordinate_s2, $system_velocity\n\n";


		open my $plt_files, "<", "$Ddat/$name1/$band_path/$name1-sort.plt"
		 or die "Cannot open '$name1-sort.plt' : $!";

		my @sort_plt = <$plt_files>;
		chomp @sort_plt;
		close $plt_files;

		my $date;
		my $peak;
		my $rms;
		my $detect;
		my $n = @sort_plt;
		$n = $n - 1;

print "$sort_plt[$n]\n";
		($date, $peak, $rms) = split (/\t+/, $sort_plt[$n]);
		my $sigma = $peak/$rms/2;
		my $flux =sprintf("%.2f", $peak*20);
		$sigma = sprintf("%.1f", $sigma);

		if($sigma >= 5){
			$detect = "Yes!($sigma)";
		}else{
			$detect = "No($sigma)";
		}

		my @source_val = join (' ', $name1, $name2, $coordinate_h, $coordinate_m, $coordinate_s, $coordinate_d, $coordinate_m2, $coordinate_s2, $system_velocity, $date, $flux, $detect, "\n");
		push @all_source_val, @source_val;

	}

	open my $maser_list, ">>", "$Dhtml/maserlist-$band.txt"
	  or die "Cannot create 'maserlist-$band.txt' : $!";
	print $maser_list @all_source_val;
	close $maser_list;

	open my $maser_list1, "<", "$Dhtml/maserlist-$band.txt"
	  or die "Cannot create 'maserlist-$band.txt' : $!";
	my @unsortlist = <$maser_list1>;
	close $maser_list1;

print "$unsortlist[10]\n";

	@unsortlist = map {$_->[0]}
	sort {$a->[3] <=> $b->[3] or $a->[4] <=> $b->[4] or $a->[5] <=> $b->[5] }
	map {[$_, split / /]} @unsortlist;

print "$unsortlist[10]\n";

	open my $maser_list2, ">", "$Dhtml/maserlist-$band_name.txt"
	  or die "Cannot create 'maserlist-$band_name.txt' : $!";
	print $maser_list2 @unsortlist;
	close $maser_list2;

}


