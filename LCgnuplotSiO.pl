#!/usr/bin/perl


$Dgnu = "/Applications/scisoft/i386/bin/gnuplot";	## Please input a directory of gnuplot ##
$Ddat = "/Users/ovo/Sites/OVO/data";				## Please input a directory of data ##

open(IN0,"@ARGV[0]");
$file = @ARGV[0];

$gnuplot = '$Dgnu -persist';

&make_gnuplot;
open(GNUPLOT,"|".$gnuplot);
foreach $k (0..$#plot){print GNUPLOT $plot[$k];}

sub make_gnuplot{
	$k=0;
	$plot[$k++] = sprintf("set xdata time\n");
	$plot[$k++] = sprintf("set timefmt \"%Y\/%m\/%d\"\n");
	$plot[$k++] = sprintf("set xlabel \"time[YY/MM]\"\n");
	$plot[$k++] = sprintf("set format x \"%y\/%m\"\n");
	$plot[$k++] = sprintf("set ylabel \"Intensity[K]\"\n");
	$plot[$k++] = sprintf("set title \"SiO maser's Light Curve\"\n");
	$plot[$k++] = sprintf("set key outside\n");
	#$plot[$k++] = sprintf("load \"/web/OVO/data/$file/SiO/$file-label.plt\"\n");
	$plot[$k++] = sprintf("set terminal png\n");
	$plot[$k++] = sprintf("set output '$Ddat/$file/SiO/$file-lc.png'\n");
	$plot[$k++] = sprintf("plot \"$Ddat/$file/SiO/v1/$file-sortv1.plt\" u 1:2 ti \"v1\" w lp , \"$Ddat/$file/SiO/v1/$file-sortv1.plt\" u 1:2:3 ti \"\" w er , \"$Ddat/$file/SiO/v2/$file-sortv2.plt\" u 1:2 ti \"v2\" w lp , \"$Ddat/$file/SiO/v2/$file-sortv2.plt\" u 1:2:3 ti \"\" w er\n");
	$plot[$k++] = sprintf("set output\n");
}
