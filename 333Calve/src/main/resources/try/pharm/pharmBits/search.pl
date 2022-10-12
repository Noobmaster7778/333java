#!perl -w
use strict;
use File::Find;
use CGI qw(:standard);
my $query = param("query");
print header();
print start_html();
print "\n<p>For the query $query, these results were found:</p>\n<ol>\n";
undef $/;

find( sub
{
 return if($_ =~ /^\./);
 return unless($_ =~ /\.html/i);
 stat $File::Find::name;
 return if -d;
 return unless -r;

 open(FILE, "< $File::Find::name") or return;
 my $string = <FILE>;
 close (FILE);

 return unless ($string =~ /\Q$query\E/i);
 my $page_title = $_;
 if ($string =~ /<title>(.*?)<\/title>/is)
 {
     $page_title = $1;
 }
 print "<li><a href=\"$File::Find::name\">$page_title</a></li>\n";
},
'/pharm/toxSite');

print "</ol>\n";
print end_html();

End