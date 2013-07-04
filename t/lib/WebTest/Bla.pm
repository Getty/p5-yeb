package WebTest::Bla;

use WebTest;

route "/bla" => sub {
	text "bla"
};

route "/x" => sub {
	text " x = ".env->{'psgix.session'}->{x}
};

1;