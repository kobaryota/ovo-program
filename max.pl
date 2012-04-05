$no = 1;				#そのファイルの最初の行を1行目とする
$max = 0;
while ($line = <>)  {
	chomp $line;
	#year
	if($no==12){		#12行目をみる。
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
	}
	#name
	#if($no==221){
	#	($a,$b,$c,$d,$e,$f) = split (/\s+/, $line);
	#	$name = $f;
	#}
	#rms
	if($no==232){
		($a,$b,$c,$d,$e,$f) = split (/\s+/, $line);
		$rms = $f;
	}
	#max
	if($no>=270 && $no<=1257){
###		($a,$ch,$vlsr,$int) = split (/\s+/, $line);
		($ch,$vlsr,$int) = split (/\s+/, $line);
		if($max < $int){
			$max = $int;
			#print $max,"\n";
		}
	}
	elsif($no>=1258 && $no<=1270){
		($ch,$vlsr,$int) = split (/\s+/, $line);
		if($max < $int){
			$max = $int;
			#print $max,"\n";
		}
	}
	++$no;
}
$err = $rms/2;
print "$year\/$month\/$day\t$max\t$err\n";
#$snr = int $max/$rms;
#print "$year\/$month\/$day\t$max\t$snr\n";
