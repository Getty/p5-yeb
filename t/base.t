#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Plack::Test;
use HTTP::Request;

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

ok(my $bla = $app->run_test_request( GET => "http://localhost/blub/bla" ), 'response on /blub/bla');
cmp_ok($bla->code, '==', 200, 'Status 200 on /blub/bla');
cmp_ok($bla->content, 'eq', 'bla', 'Expected content on /blub/bla');

done_testing;
