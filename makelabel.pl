while ($line = <>)  {
        chomp $line;
	($time1,$int1,$snr1) = split (/\s+/, $line);
	open(OUT,">> label.plt");
	print(OUT "set label \"SNR=$snr1\" at \"$time1\",$int1\n");
	close(OUT);
}
