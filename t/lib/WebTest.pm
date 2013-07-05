package WebTest;

use Yeb;

plugin 'Static';
load 'Static';

r "/" => sub {
	text "root";
};

r "/a/..." => sub {
	ex( [qw( x y )] => 'export a' );
	st( [qw( y x )] => 'stash a' );
	st( [qw( a )] => 'single b a' );
	st( c => 'single c a' );
	chain 'Bla';
};

r "/b/..." => sub {
	ex( [qw( x y )] => 'export b' );
	st( [qw( y x )] => 'stash b' );
	st( [qw( a )] => 'single a b' );
	st( c => 'single c b' );
	chain 'Bla';
};

1;