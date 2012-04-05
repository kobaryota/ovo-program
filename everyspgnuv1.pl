#!/usr/bin/perl
open(IN0,"@ARGV[0]");
$file = @ARGV[0];
($mae,$file2) = split (/SiO\/v1\//, $file);
($name,$ushiro) = split (/\_Qv1\_/, $file2);
while ($line = <IN0>) {
	chomp $line;
	if($line =~ /\#/){
		$date = $line;
		$date =~ s/\#//;
		$date2 = $date;
		$date2 =~ s/\///g;
	}
	if($. == 2){
		($xmin,$y) = split(/\s/, $line);
	}
	if($. == 1002){
		($xmax,$y) = split(/\s/, $line);
	}
}
#print "xmin=$xmin,xmax=$xmax\n";
close(IN0);

$gnuplot = '/usr/bin/gnuplot -persist';

&make_gnuplot;
open(GNUPLOT,"|".$gnuplot);
foreach $k (0..$#plot){print GNUPLOT $plot[$k];}

sub make_gnuplot{
	$k=0;
	$plot[$k++] = sprintf("set xlabel \"Vlsr[km/s]\"\n");
	$plot[$k++] = sprintf("set mxtics\n");
	$plot[$k++] = sprintf("set xrange [$xmin-1:$xmax+1]\n");
#	$plot[$k++] = sprintf("set autoscale\n");
	$plot[$k++] = sprintf("set ylabel \"Intensity[K]\"\n");
	$plot[$k++] = sprintf("set title \"SiO Maser's Spectrum of $date\"\n");
	$plot[$k++] = sprintf("set key outside\n");
#	$plot[$k++] = sprintf("plot \"$file\" ind 0 u 1:2 ti \"\" w l\n");
        $plot[$k++] = sprintf("set terminal png\n");
	$plot[$k++] = sprintf("set output '/web/OVO/data/$name/SiO/v1/$name\_$date2.png'\n");
	$plot[$k++] = sprintf("plot \"/web/OVO/data/$name/SiO/v1/$file2\" u 1:2 ti \"\" w l\n");
	$plot[$k++] = sprintf("set output\n");
#       $plot[$k++] = sprintf("set terminal x11\n");
}
