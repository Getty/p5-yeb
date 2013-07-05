package WebTest;

use Yeb;

plugin 'Static';
load 'Static';

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