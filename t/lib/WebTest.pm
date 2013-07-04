package WebTest;

use Yeb;
use Plack::Middleware::Session;
use Plack::Session::Store::File;

middleware(Plack::Middleware::Session->new(
	store => Plack::Session::Store::File->new
));

route "/" => sub {
	env->{'psgix.session'}->{x} = p('x');
	text "root"
};

route "/blub/..." => sub { chain 'Bla' };

1;