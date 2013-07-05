#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Path::Tiny qw( path );

use FindBin qw($Bin);
use lib "$Bin/lib";

$ENV{YEB_ROOT} = $Bin;

use_ok('WebTest');

my $app = WebTest->new;

my @tests = (
	[ '', 'root' ],
	[ 'nomistadontshoot', qr/i am out of here/, 500 ],
	[ 'a/', qr/i am out of here/, 500 ],
	[ 'a/bla', 'export a stash a single b a single c a bla' ],
	[ 'b/bla', 'export b stash b single a b single c b bla' ],
	[ 'images/notfound', undef, 404 ],
	[ 'images/test.jpg', path($Bin,'htdocs','images','test.jpg')->slurp, 200 ],
	[ 'robots.txt', 'robots.txt' ],
	[ 'js/test.js', 'js/test.js' ],
	[ 'subdir/test.js', 'subdir/test.js' ],
);

for (@tests) {
	my $path = $_->[0];
	my $url = "http://localhost/".$path;
	my $test = $_->[1];
	my $code = defined $_->[2] ? $_->[2] : 200;
	ok(my $res = $app->run_test_request( GET => $url ), 'response on /'.$path);
	cmp_ok($res->code, '==', $code, 'Status '.$code.' on /'.$path);
	if (ref $test eq 'Regexp') {
		like($res->content, $test, 'Expected content on /'.$path);
	} elsif (defined $test) {
		cmp_ok($res->content, 'eq', $test, 'Expected content on /'.$path);
	}
}

done_testing;
