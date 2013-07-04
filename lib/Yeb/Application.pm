package Yeb::Application;
# ABSTRACT: Main Meta Class for a Yeb Application

use Moo;
use Package::Stash;
use Import::Into;
use Yeb::Context;
use Yeb::Class;

use Web::Simple ();

has class => (
	is => 'ro',
	required => 1,
);

has args => (
	is => 'ro',
);

has config => (
	is => 'ro',
	lazy => 1,
	builder => sub {{}},
);

has package_stash => (
	is => 'ro',
	lazy => 1,
	builder => sub { Package::Stash->new(shift->class) },
);

has yebs => (
	is => 'ro',
	lazy => 1,
	builder => sub {{}},
);
sub y { shift->yebs->{shift} }

has functions => (
	is => 'ro',
	lazy => 1,
	builder => sub {{}},
);

sub BUILD {
	my ( $self ) = @_;

	$self->package_stash->add_symbol('$yeb',\$self);
	
	Web::Simple->import::into($self->class);
	
	$self->package_stash->add_symbol('&dispatch_request',sub {
		my ( undef, $env ) = @_;
		$self->reset_context;
		my $context = Yeb::Context->new( env => $env );
		$self->current_context($context);
		my @chain = $self->yebs->{$self->class}->chain;
		return $self->yebs->{$self->class}->chain,
			'/...' => sub { $self->current_context->response };
	});

	$self->yeb_import($self->class);
	
	$self->yebs->{$self->class}->add_to_chain();

	$self->package_stash->add_symbol('&import',sub {
		my ( $class, $alias ) = @_;
		my $target = caller;
		$self->yeb_import($target, $alias);
	});
}

has current_context => (
	is => 'rw',
	clearer => 'reset_context',
);

sub yeb_import {
	my ( $self, $target ) = @_;
	$self->yebs->{$target} = Yeb::Class->new(
		app => $self,
		class => $target,
	);
}

sub register_function {
	my ( $self, $func, $coderef ) = @_;
	die "Function ".$func." already defined" if defined $self->functions->{$func};
}

1;