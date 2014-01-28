#!/usr/bin/perl

use CGI;
use DBI();


my $dbh = DBI->connect("DBI:Pg:host=<HOST>;db=<DB>", "<USERNAME>", "<PASSWORD>", {'RaiseError' => 1});
my $q = CGI->new;

my $sth;
my $ref;
my $highid;

$sth = $dbh->prepare("SELECT id, time, quote, via, url, caption FROM mefi ORDER BY id DESC LIMIT 25");
$sth->execute;

print "<?xml version=\"1.0\" encoding=\"UTF-8\" ?> <rss version=\"2.0\">\n\n";

print "<channel><title>#mefi Link Log</title><link>http://mefi.inactivex.net/mefi.rss</link><description>#mefi Link Log</description>\n\n";

while ($ref = $sth->fetchrow_hashref())
{
	my $post_time = localtime($ref->{'time'});
	my $via = $ref->{'via'};
	my $url = $ref->{'url'};

	if (defined $ref->{'url'})
	{
		print "<item><author>$via</author><pubDate>$post_time</pubDate><title>$url</title><link>$url</link><description>Posted at $post_time by $via</description></item>\n\n";
	}
}

$sth->finish();

print "</channel></rss>\n\n";




exit;
