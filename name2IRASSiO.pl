###�Ѵ�̾�������2�İʾ���פ����Τ����ä������б����Դ���
###sh�ե����������Ǥ��Ф��ơ��ܻ��ǧ��ɬ��
###����̵���ξ��ϡ�nohit�˰�ư�����Τǳ�ǧ�����Ѵ�̾�����򽼼¤�����
#!/usr/bin/perl
system("ls *Qv*.txt > sample.txt");
#$banda = "_Qv";
$no = 0;
print "mkdir -p nonhit\n";
open(IN,"sample.txt");					#���Ϸ��txt�ΰ������ɤ߹��ࡣ
while ($line = <IN>)  {
	chomp $line;
	if(grep /Qv1/, $line){$banda = "_Qv1_";$bandb = "_Qv1_";}
	if(grep /Qv2/, $line){$banda = "_Qv2_";$bandb = "_Qv2_";}
	($name,$ushiro) = split (/\_Qv.\_/, $line);		#_K_�������ʬ���롣
#	($nameQ,$ushiro) = split (/\Qv/, $line);		#_K_�������ʬ���롣
	$name =~ s/\+/\\\+/c;				#+����꤯ǧ������ʤ�����\���դ��롣
#	$nameQ =~ s/\+/\\\+/c;				#+����꤯ǧ������ʤ�����\���դ��롣
#	if($nameQ=~/Q_/){
#		($name,$Qdami)=split(/Q_/,$nameQ);
#		$bandb = "Q_Qv";
#	}else{
#		($name,$Qdami)=split(/_/,$nameQ);
#		$bandb = "_Qv";
#	}
	$ushiro =~ s/\*//;				#�ե�����̾�κǸ��*���դ��Ƥ�����Ͼä���
	open(IN2,"/Users/sio/ovo/OVO/program/allrename.txt");#�Ѵ�̾�������ɤ߹��ࡣ
	while ($pattern = <IN2>){
		chomp $pattern;
		if($pattern =~ / $name,/i){		#���ڡ�����,�˰Ϥޤ줿ŷ��̾���羮ʸ�����̤������������
			++$no;				#���פ����Τ������no��1��­��
			if($no == 1){			#no��1���Ĥޤ���פ�����Τ�1�Ĥʤ�
				($real,$two) = split (/,\s/,$pattern);
				$name =~ s/\\//g;	#+��ǧ�������뤿���\��ä�
				$real =~ s/ //;		
				print "cp $name$bandb$ushiro $real$banda$ushiro\n";	#�ե�����̾�Ѵ�
				print "mv $real$banda$ushiro \/Users\/sio\/ovo\/OVO\/inputbox\/\n";	#inputbox��copy
			}
			if($no >= 2){
				print "-----------attention!! $name is double booking!-------------\n";	#���פ����Τ�2�İʾ夢���硢�ٹ�ʸ
#				print "mv $name$band$ushiro nonhit\n\n"
				print "mv $name$banda$ushiro nonhit\n\n"
			}	
		}
	}
	close(IN2);
	if($no == 0){				#���פ����Τ�̵�����
		$name =~ s/\\//g;
		print "mv $name$bandb$ushiro nonhit\n";	#nohit�Ȥ���dir��ž��
	}
	$no = 0;
}
close(IN);
system("rm sample.txt");
