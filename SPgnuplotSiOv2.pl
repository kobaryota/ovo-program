#!/usr/bin/perl


$Dgnu = "/Applications/scisoft/i386/bin/gnuplot";	## Please input a directory of gnuplot ##
$Ddat = "/Users/ovo/Sites/OVO/data";				## Please input a directory of data ##

open(IN0,"@ARGV[0]");
$filesp = @ARGV[0];
$file = $filesp;
($mae,$ushiro) = split (/\_Qv2\_/, $file);
($mae2,$name) = split (/v2\//, $mae);
$wc = `wc -l $filesp`;
($s,$gyosu) = split(/\s+/, $wc);
#print "$wc,$gyosu\n";
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
        if($. == $gyosu){
                ($xmax,$y) = split(/\s/, $line);
        }
}

$gnuplot = '$Dgnu -persist';

&make_gnuplot;
open(GNUPLOT,"|".$gnuplot);
foreach $k (0..$#plot){print GNUPLOT $plot[$k];}

sub make_gnuplot{
	$k=0;
	$plot[$k++] = sprintf("set xlabel \"Vlsr[km/s]\"\n");
	$plot[$k++] = sprintf("set mxtics\n");
	$plot[$k++] = sprintf("set xrange [$xmax+1:$xmin-1]\n");
	$plot[$k++] = sprintf("set ylabel \"Intensity[K]\"\n");
	$plot[$k++] = sprintf("set title \"SiO Maser's v=2 Spectrum of $date\"\n");
	$plot[$k++] = sprintf("set key outside\n");
        $plot[$k++] = sprintf("set terminal png\n");
	$plot[$k++] = sprintf("set output '$Ddat/$name/SiO/v2/$name\_$date2.png'\n");
	$plot[$k++] = sprintf("plot \"$filesp\" u 1:2 ti \"\" w l\n");
	$plot[$k++] = sprintf("set output\n");
#       $plot[$k++] = sprintf("set terminal x11\n");
}
