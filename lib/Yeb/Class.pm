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

sub BUILD {
	my ( $self ) = @_;

	$self->add_function('yeb',sub { $self->app });

	$self->add_function('chain',sub {
		my $class = shift;
		if ($class =~ m/^\+/) {
			$class =~ s/^(\+)//;
		} else {
			$class = $self->app->class.'::'.$class;
		}
		load_class($class) unless is_class_loaded($class);
		return $self->app->y($class)->chain;
	});

	$self->add_function('cfg',sub {
		$self->app->config
	});

	$self->add_function('cc',sub {
		$self->app->cc
	});

	$self->add_function('env',sub {
		$self->app->cc->env
	});

	$self->add_function('req',sub {
		$self->app->cc->request
	});

	$self->add_function('root',sub {
		path($self->app->root,@_);
	});

	$self->add_function('cur',sub {
		path($self->app->current_dir,@_);
	});

	$self->add_function('plugin',sub {
		$self->app->add_plugin($self->class,@_);
	});

	$self->add_function('st',sub {
		my $key = shift;
		return $self->app->cc->stash unless defined $key;
		return $self->app->cc->stash->{$key};
	});

	$self->add_function('pa',sub {
		my $value = $self->app->cc->request->param(@_);
		defined $value ? $value : "";
	});

	$self->add_function('has_pa',sub {
		my $value = $self->app->cc->request->param(@_);
		defined $value ? 1 : 0;
	});

	$self->add_function('r',sub {
		$self->add_to_chain(@_);
	});

	$self->add_function('middleware',sub {
		my $middleware = shift;
		$self->prepend_to_chain( "" => sub { $middleware } );
	});

	$self->add_function('text',sub {
		$self->app->cc->content_type('text/plain');
		$self->app->cc->body(@_);
		$self->app->cc->response;
	});

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


