#!/usr/local/bin/perl
print "Content-type: text/html; charset=euc-jp\n\n";

print "<html>\n";
print "<head>\n";
print "<title>VERA SingleDish Observation @ IRIKI Result Sheet</title>\n</head>\n";
print "<body>\n";

print "<h2>VERA SingleDish Observation @ IRIKI Result Sheet</h2>\n";
open(IN,"SourceList.txt");
@basic = <IN>;
chomp @basic;
close(IN);
print "<table>\n";
print "<tr><td>No.</td><td>name1</td><td>name2</td><td>R.A.</td><td></td><td></td><td>Dec.</td><td></td><td></td><td>epoch</td><td>Vlsr</td><td>Obs. Date</td><td>Flux(Jy)</td></tr>\n";
foreach $basic (@basic){
        ($b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$b10,$b11,$b12) = split (/\s+/, $basic);
        $b8 = $b7 * $b8;
        print "<tr><td>$b1</td><td>$b2</td><td>$b3</td><td>$b4</td><td>$b5</td><td>$b6</td><td>$b8</td><td>$b9</td><td>$b10</td><td>$b11</td><td>$b12</td>";
        system("tail -1 /home/ryota/Desktop/OVO-AUTO/HTML/data/$b2/H2O/$b2-sort.plt > $b2-newobs.txt");
        open(IN2,"$b2-newobs.txt");
        @obs = <IN2>;
        chomp @obs;
        close(IN2);
        foreach $obs (@obs){
                ($o1,$o2,$o3) = split (/\s+/, $obs);
                $o2 = $o2 * 20;
                print "<td>$o1</td><td>$o2</td>";
        }
        print "</tr>\n";
}
print "</table>\n";
system("rm *newobs.txt\n");

print  "</body>\n";
print  "</html>\n";

