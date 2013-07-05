package Yeb::Class;
# ABSTRACT: Meta Class for all Yeb application classes

use Moo;
use Package::Stash;
use Class::Load ':all';
use Path::Tiny qw( path );

has app => (
	is => 'ro',
	required => 1,
);

has class => (
	is => 'ro',
	required => 1,
);

has package_stash => (
	is => 'ro',
	lazy => 1,
	builder => sub { Package::Stash->new(shift->class) },
);
sub add_function {
	my ( $self, $func, $coderef ) = @_;
	$self->package_stash->add_symbol('&'.$func,$coderef);
}

has chain_links => (
	is => 'ro',
	lazy => 1,
	builder => sub {[]},
);
sub chain { @{shift->chain_links} }
sub add_to_chain { push @{shift->chain_links}, @_ }
sub prepend_to_chain { unshift @{shift->chain_links}, @_ }

has yeb_class_functions => (
	is => 'ro',
	lazy => 1,
	builder => sub {
		my ( $self ) = @_;
		{
			plugin => sub { $self->app->add_plugin($self->class,@_) },

			r => sub { $self->add_to_chain(@_) },
			middleware => sub {
				my $middleware = shift;
				$self->prepend_to_chain( "" => sub { $middleware } );
			}
		}
	},
);

sub BUILD {
	my ( $self ) = @_;

	for (keys %{$self->app->yeb_functions}) {
		$self->add_function($_,$self->app->yeb_functions->{$_});
	}

	for (keys %{$self->yeb_class_functions}) {
		$self->add_function($_,$self->yeb_class_functions->{$_});
	}
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


