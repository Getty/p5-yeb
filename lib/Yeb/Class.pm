package Yeb::Class;
# ABSTRACT: Meta Class for all Yeb Application classes

use Moo;
use Package::Stash;
use Class::Load ':all';

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
sub pre_add_to_chain { unshift @{shift->chain_links}, @_ }

sub BUILD {
	my ( $self ) = @_;
	my $p = $self->package_stash;

	$p->add_symbol('&yeb',sub { $self->app });

	$p->add_symbol('&chain',sub {
		my $class = shift;
		if ($class =~ m/^\+/) {
			$class =~ s/^(\+)//;
		} else {
			$class = $self->app->class.'::'.$class;
		}
		load_class($class) unless is_class_loaded($class);
		return $self->app->y($class)->chain;
	});

	$p->add_symbol('&cfg',sub {
		$self->app->config
	});

	$p->add_symbol('&env',sub {
		$self->app->current_context->env
	});

	$p->add_symbol('&req',sub {
		$self->app->current_context->request
	});

	$p->add_symbol('&s',sub {
		my $key = shift;
		return $self->app->current_context->stash unless defined $key;
		return $self->app->current_context->stash->{$key};
	});

	$p->add_symbol('&p',sub {
		my $value = $self->app->current_context->request->param(@_);
		defined $value ? $value : "";
	});

	$p->add_symbol('&has_p',sub {
		my $value = $self->app->current_context->request->param(@_);
		defined $value ? 1 : 0;
	});

	$p->add_symbol('&route',sub {
		$self->add_to_chain(@_);
	});

	$p->add_symbol('&middleware',sub {
		my $middleware = shift;
		$self->add_to_chain( "" => sub { $middleware } );
	});

	$p->add_symbol('&text',sub {
		$self->app->current_context->content_type('text/plain');
		$self->app->current_context->body(@_);
		$self->app->current_context->response;
	});

}

1;