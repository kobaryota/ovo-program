###�Ѵ�̾��������2�İʾ����פ������Τ����ä��������б����Դ���
###sh�ե����������Ǥ��Ф��ơ��ܻ���ǧ��ɬ��
###����̵���ξ����ϡ�nohit�˰�ư�������Τǳ�ǧ�����Ѵ�̾�����򽼼¤�����
#!/usr/bin/perl
system("ls *.txt > sample.txt");
$band = "\_K\_";
$no = 0;
print "mkdir nonhit\n";
open(IN,"sample.txt");					#���Ϸ���txt�ΰ������ɤ߹��ࡣ
while ($line = <IN>)  {
	chomp $line;
	($name,$ushiro) = split (/\_K\_/, $line);	#_K_��������ʬ���롣
	$name =~ s/\+/\\\+/c;				#+�����꤯ǧ�������ʤ�����\���դ��롣
	$ushiro =~ s/\*//;				#�ե�����̾�κǸ���*���դ��Ƥ��������Ͼä���
	open(IN2,"/home/ryota/ovo/OVO/program/allrename.txt");#�Ѵ�̾�������ɤ߹��ࡣ
	while ($pattern = <IN2>){
		chomp $pattern;
		if($pattern =~ / $name,/i){		#���ڡ�����,�˰Ϥޤ줿ŷ��̾���羮ʸ�����̤�������������
			++$no;				#���פ������Τ�������no��1��­��
			if($no == 1){			#no��1���Ĥޤ����פ������Τ�1�Ĥʤ�
				($real,$two) = split (/,\s/,$pattern);
				$name =~ s/\\//g;	#+��ǧ�������뤿����\���ä�
				$real =~ s/ //;		
				print "cp $name$band$ushiro $real$band$ushiro\n";	#�ե�����̾�Ѵ�
				print "mv $real$band$ushiro \/home\/ryota\/ovo\/OVO\/inputbox\/\n";	#inputbox��copy
#				print "mv $real$band$ushiro \/Volumes\/sioHD\/ovo\/OVO\/inputbox\/\n";	#inputbox��copy
			}
			if($no >= 2){
				print "-----------attention!! $name is double booking!-------------\n";	#���פ������Τ�2�İʾ夢�����硢�ٹ�ʸ
				print "mv $name$band$ushiro nonhit\n\n"
			}	
		}
	}
	close(IN2);
	if($no == 0){				#���פ������Τ�̵������
		$name =~ s/\\//g;
		print "mv $name$band$ushiro nonhit\n";	#nohit�Ȥ���dir��ž��
	}
	$no = 0;
}
close(IN);
system("rm sample.txt");