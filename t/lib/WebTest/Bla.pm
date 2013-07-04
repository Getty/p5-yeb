package WebTest::Bla;

use WebTest;

r "/bla" => sub {
	text "bla"
};

r "/x/json" => sub {
	st->{x}->{x} = session('x');
	json;
};

r "/x" => sub {
	text " x = ".session('x');
};

1;