package Yeb::Context;
# ABSTRACT: Storage for context of request

use Moo;
use Plack::Request;
use URI;

has env => (
	is => 'ro',
	required => 1,
);

has stash => (
	is => 'ro',
	lazy => 1,
	builder => sub {{}},
);

has export => (
	is => 'ro',
	lazy => 1,
	builder => sub {{}},
);

has header => (
	is => 'ro',
	lazy => 1,
	builder => sub {{}},
);

has request => (
	is => 'ro',
	lazy => 1,
	builder => sub { Plack::Request->new(shift->env) },
);

has uri_base => (
	is => 'rw',
	lazy => 1,
	builder => sub { shift->request->base },
);

sub uri_for { # TODO supporting several args and hash as args
	my($self, $path, $args) = @_;
	my $uri = $self->uri_base;
	$uri->path($uri->path . $path);
	$uri->query_form(@$args) if $args;
	$uri;
}

has status => (
	is => 'rw',
	lazy => 1,
	builder => sub { 200 },
	predicate => 1,
);

has body => (
	is => 'rw',
	lazy => 1,
	builder => sub { "Nothing todo, i am out of here" },
	predicate => 1,
);

has content_type => (
	is => 'rw',
	lazy => 1,
	builder => sub { "text/html" },
	predicate => 1,
);

sub response {
	my $self = shift;
	[
		$self->status,
		[
			content_type => $self->content_type,
			%{$self->header},
		],
		[ $self->body ]
	]
}

1;

=head1 SUPPORT

IRC

  Join #web-simple on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-yeb
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-yeb/issues


