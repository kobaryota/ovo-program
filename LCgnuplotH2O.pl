#!/usr/bin/perl

#$Dgnu = "/usr/local/bin/gnuplot";			## Please input a directory of gnuplot ##
$Ddat = "/Users/sio/ovo/OVO/data";			## Please input a directory of data ##

open(IN0,"@ARGV[0]");
$file = @ARGV[0];
($mae,$file2)=split(/H2O/,$file);
($name,$ushiro)=split(/-sort/,$file2);
close(IN0);

###$gnuplot = '/usr/bin/gnuplot -persist';######## change this line ! ######
#$gnuplot = '$Dgnu -persist';
$gnuplot = '/sw/bin/gnuplot -persist';
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
	$plot[$k++] = sprintf("set title \"H2O maser's Light Curve\"\n");
	$plot[$k++] = sprintf("set key outside\n");
#	$plot[$k++] = sprintf("load \"/web/OVO/data/$file/H2O/$file-label.plt\"\n");
#	$plot[$k++] = sprintf("plot \"/web/OVO/data/$file/H2O/$file-sort.plt\" u 1:2 ti \"\" w lp\n");
	$plot[$k++] = sprintf("set terminal png\n");
###	$plot[$k++] = sprintf("set output '/web/OVO/data/$file/H2O/$file-lc.png'\n");### change this line ! #######
	$plot[$k++] = sprintf("set output '$Ddat/$name/H2O/$name-lc.png'\n");
	$plot[$k++] = sprintf("plot \"$file\" u 1:2 ti \"\" w lp, \"$file\" u 1:2:3 ti \"\" w er\n");
	$plot[$k++] = sprintf("set output\n");
#	$plot[$k++] = sprintf("set terminal x11\n");
}
