print "作業場所を入力\n例）/home/ryota/Desktop\n";
$sagyou = <STDIN>;
print "作成したいディレクトリの名前を入力\n";
$dir = <STDIN>;
system("mkdir $sagyou\/$dir\/");
print "振り分けたいものの名前を入力\n例）*1007*.txt\n";
$furi = <STDIN>;
system("mv $sagyou\/$furi $sagyou\/$dir\/");
