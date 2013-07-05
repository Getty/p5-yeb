package WebTest::Bla;

use WebTest;

r "/bla" => sub {
	text st->{was}."bla"
};

1;