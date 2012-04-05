#!/usr/bin/perl
$no = 1;
$max = 0;
$file = @ARGV[0];
$wc = `wc -l $file`;
($aaa,$gyosu) = split(/\s+/, $wc);
$gyousu = $gyosu-12;
while ($line = <>)  {
	chomp $line;
	#year
	if($no==12){
		($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $line);
		$year = $g;
	}
	#month
	if($no==13){
		($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $line);
		if($g<=9) {$month = 0 . $g;}
		else {$month = $g;}
	}
	#day
	if($no==14){
		($a,$b,$c,$d,$e,$f,$g) = split (/\s+/, $line);
		if($g<=9) {$day = 0 . $g;}
		else {$day = $g;}
		print "\#$year\/$month\/$day\n";
	}
	#spectrum
	if($no>=270 && $no<=1257){
		($a,$ch,$vlsr,$int) = split (/\s+/, $line);
		if($a =~ /[0-9]/){
			($ch,$vlsr,$int) = split (/\s+/, $line);
		}
		print "$vlsr\t$int\n";
	}
	elsif($no>=1258 && $no<=$gyousu){
		($ch,$vlsr,$int) = split (/\s+/, $line);
		print "$vlsr\t$int\n";
	}
	++$no;
}
