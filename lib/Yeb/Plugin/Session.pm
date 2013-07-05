package Yeb::Plugin::Session;

use Moo;
use Plack::Middleware::Session;
use Plack::Session::Store::File;

has app => ( is => 'ro', required => 1 );

sub BUILD {
	my ( $self ) = @_;
	$self->app->add_middleware(Plack::Middleware::Session->new(
		store => Plack::Session::Store::File->new
	));
	$self->app->register_function('session',sub {
		my $key = shift;
		return $self->app->cc->env->{'psgix.session'} unless defined $key;
		return $self->app->cc->env->{'psgix.session'}->{$key};
	});
}

1;