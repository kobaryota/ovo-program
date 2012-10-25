print "Content-Type: text/html; charset=Shift_JIS\n\n";
print "<html>\n";
print "<head><title>アクセスカウンタ</title></head>\n";
print "<body>\n";

if (open(FH, "/home/ryota/Desktop/ovokoba/counter/counter.txt")) {
  $count = <FH>;
  close(FH);

  $count++;

  print "<p>あなたは$count人目の訪問者です。</p>\n";

  if (open(FH, ">/home/ryota/Desktop/ovokoba/counter/counter.txt")) {
    print FH $count;
    close(FH);
  } else {
    print "<p>ファイルに書き込めません。</p>";
  }
} else {
  print "<p>ファイルを読み込めません。</p>";
}

print "</body>\n";
print "</html>\n";

exit;
