package Yeb::Plugin::Session;
# ABSTRACT: Yeb Plugin for Plack::Middleware::Session

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
		$self->app->hash_accessor_empty($self->app->cc->env->{'psgix.session'},@_);
	});
	$self->app->register_function('session_has',sub {
		$self->app->hash_accessor_has($self->app->cc->env->{'psgix.session'},@_);
	});
}

1;

=encoding utf8

=head1 SYNOPSIS

  package MyYeb;

  use Yeb;

  BEGIN {
    plugin 'Session';
  }

  1;

=head1 FRAMEWORK FUNCTIONS

=head2 session

=head2 session_has

=head1 SUPPORT

IRC

  Join #web-simple on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-yeb
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-yeb/issues


