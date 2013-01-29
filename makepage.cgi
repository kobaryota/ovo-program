#!/usr/local/bin/perl

sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ); }
$pai = atan2(1.0,1.0)*4;

print "Content-type: text/html; charset=euc-jp";
print "Content-type: image/png\n\n";

print  "<html>\n";
print  "<head>\n";
print  "<title>Query by Coodirate</title></head>\n";
print  "<body>\n";
use CGI qw(param);
$QbC = param('QbC');
print "$QbC<br>\n";
print  "</body>\n";
print  "</html>\n";
