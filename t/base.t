#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use FindBin qw($Bin);
use lib "$Bin/lib";

use_ok('WebTest');

my $app = WebTest->new;

ok(my $root = $app->run_test_request( GET => "http://localhost/" ), 'response on /');
cmp_ok($root->code, '==', 200, 'Status 200 on /');
cmp_ok($root->content, 'eq', 'root', 'Expected content on /');

ok(my $blub = $app->run_test_request( GET => "http://localhost/blub/" ), 'response on /blub/');
cmp_ok($blub->code, '==', 500, 'Status 500 on /blub/');
like($blub->content, qr/i am out of here/, 'Expected error on /blub/');

ok(my $blubbla = $app->run_test_request( GET => "http://localhost/blub/bla" ), 'response on /blub/bla');
cmp_ok($blubbla->code, '==', 200, 'Status 200 on /blub/bla');
cmp_ok($blubbla->content, 'eq', 'blubbla', 'Expected content on /blub/bla');

ok(my $blehbla = $app->run_test_request( GET => "http://localhost/bleh/bla" ), 'response on /bleh/bla');
cmp_ok($blehbla->code, '==', 200, 'Status 200 on /bleh/bla');
cmp_ok($blehbla->content, 'eq', 'blehbla', 'Expected content on /bleh/bla');

done_testing;
