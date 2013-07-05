#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Path::Tiny;

use FindBin qw($Bin);
use lib "$Bin/lib";

SKIP: {
	eval {
		require Text::Xslate;
		require JSON;
		require Plack::Middleware::Session;
	};

	skip "Text::Xslate, JSON or Plack::Middleware::Session is not installed", 1 if $@;

	$ENV{YEB_ROOT} = $Bin;

	use_ok('WebXslate');

	my $app = WebXslate->new;

	ok(my $root = $app->run_test_request( GET => "http://localhost/" ), 'response on /');
	cmp_ok($root->code, '==', 200, 'Status 200 on /');
	cmp_ok($root->content, 'eq', 'index page_include[page[root]]', 'Expected content on /');

	ok(my $test = $app->run_test_request( GET => "http://localhost/test" ), 'response on /test');
	cmp_ok($test->code, '==', 200, 'Status 200 on /test');
	cmp_ok($test->content, 'eq', 'index/test page_include[page[test]]', 'Expected content on /test');
}


done_testing;
