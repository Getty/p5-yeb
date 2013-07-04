package WebTest;

use Yeb;

BEGIN {
	plugin 'Session';
	plugin 'JSON';
}

r "/" => sub {
	session->{x} = pa('x');
	text "root";
};

r "/blub/..." => sub {
	st->{blub} = 1;
	chain 'Bla';
};

1;