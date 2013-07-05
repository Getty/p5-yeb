package WebTest;

use Yeb;

r "/" => sub {
	text "root";
};

r "/blub/..." => sub {
	st->{was} = 'blub';
	chain 'Bla';
};

r "/bleh/..." => sub {
	st->{was} = 'bleh';
	chain 'Bla';
};

1;