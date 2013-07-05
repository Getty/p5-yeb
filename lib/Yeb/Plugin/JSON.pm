package Yeb::Plugin::JSON;
# ABSTRACT: Yeb Plugin for JSON response

use Moo;
use JSON;

has app => ( is => 'ro', required => 1 );

sub get_vars {
	my ( $self, $user_vars ) = @_;
	my %stash = %{$self->app->cc->stash};
	my %user = defined $user_vars ? %{$user_vars} : ();
	return $self->app->merge_hashs(
		$self->app->cc->export,
		\%user
	);
}

sub BUILD {
	my ( $self ) = @_;
	$self->app->register_function('json',sub {
		my $user_vars = shift;
		my $vars = $self->get_vars($user_vars);
		$self->app->cc->content_type('application/json');
		$self->app->cc->body(to_json($vars,@_));
		$self->app->cc->response;
	});
}

1;

=encoding utf8

=head1 SYNOPSIS

  package MyYeb;

  use Yeb;

  BEGIN {
    plugin 'JSON';
  }

  r "/" => sub {
    ex key => 'value';
    json { other_key => 'value' };
  };

  1;

=head1 FRAMEWORK FUNCTIONS

=head2 json

=head1 SUPPORT

IRC

  Join #web-simple on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-yeb
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-yeb/issues


