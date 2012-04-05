open(IN,"newdata.lst");
@file = <IN>;
chomp @file;
close(IN);
#inputbox内のtxtを各天体のdirに移動。
foreach $name (@file){
	#$file = substr($file, 18);
	#($name,$ushiro) = split (/\_K\_/, $file);
	chomp $name;
	system("ls ../data/$name/H2O/$name*IRK.txt > $name\_allsp.txt");
	system("ls ../data/$name/SiO/v1/$name*MIZ.txt > $name\_allspv1.txt");
	system("ls ../data/$name/SiO/v2/$name*MIZ.txt > $name\_allspv2.txt");
        open(INh,"$name\_allsp.txt");
        @sptxt = <INh>;
        chomp @sptxt;
	close(INh);
	foreach $sptxt (@sptxt){
		($mae,$ushiro) = split(/H2O\//, $sptxt);
		($forplt) = split(/.txt/, $ushiro);
		system("perl txt2sp.pl ../data/$name/H2O/$forplt.txt > ../data/$name/H2O/$forplt.plt");
		open(OUT,">> plot.sh");
		print(OUT "perl everyspgnu.pl ../data/$name/H2O/$forplt.plt\n");
        	close(OUT);
	}
        open(INv1,"$name\_allspv1.txt");
        @sptxt = <INv1>;
        chomp @sptxt;
	close(INv1);
	foreach $sptxt (@sptxt){
		($mae,$ushiro) = split(/SiO\/v1\//, $sptxt);
		($forplt) = split(/.txt/, $ushiro);
		system("perl txt2sp.pl ../data/$name/SiO/v1/$forplt.txt > ../data/$name/SiO/v1/$forplt.plt");
		open(OUT1,">> plot1.sh");
		print(OUT1 "perl everyspgnuv1.pl ../data/$name/SiO/v1/$forplt.plt\n");
        	close(OUT1);
	}
        open(INv2,"$name\_allspv2.txt");
        @sptxt = <INv2>;
        chomp @sptxt;
	close(INv2);
	foreach $sptxt (@sptxt){
		($mae,$ushiro) = split(/SiO\/v2\//, $sptxt);
		($forplt) = split(/.txt/, $ushiro);
		system("perl txt2sp.pl ../data/$name/SiO/v2/$forplt.txt > ../data/$name/SiO/v2/$forplt.plt");
		open(OUT2,">> plot2.sh");
		print(OUT2 "perl everyspgnuv2.pl ../data/$name/SiO/v2/$forplt.plt\n");
        	close(OUT2);
	}
        system("sh plot.sh");
	system("ls -r /web/OVO/data/$name/H2O/$name\_20*.png > /web/OVO/data/$name/SiO/v1/$name\_allsp.lst");
        system("sh plot1.sh");
	system("ls -r /web/OVO/data/$name/SiO/v1/$name\_20*.png > /web/OVO/data/$name/SiO/v1/$name\_allsp.lst");
        system("sh plot2.sh");
	system("ls -r /web/OVO/data/$name/SiO/v2/$name\_20*.png > /web/OVO/data/$name/SiO/v2/$name\_allsp.lst");
	system("rm -f plot*.sh");
	system("rm -f $name\_allsp*.txt");
}
