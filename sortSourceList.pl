#!/usr/bin/perl

use strict;
use warnings;

#my $directory = /Users/sio/ovo/OVO/list/;
#my $a;
#my $b;

print "Please type Sorting list name in full-pass.";
my $list_name = <STDIN>;
print "$list_name";
open(IN1,"/Users/sio/ovo/OVO/list/$list_name");
my @unsortlist = <IN1>;
#chomp @unsortlist;
close(IN1);
@unsortlist = map {$_->[0]}
sort {$a->[3] <=> $b->[3] or $a->[4] <=> $b->[4] or $a->[5] <=> $b->[5] }
map {[$_, split / /]} @unsortlist;

print "@unsortlist €n";
	     
open(OUT1,"> $list_name");
print OUT1 @unsortlist;
close(OUT1);