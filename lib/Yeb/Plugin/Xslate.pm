package Yeb::Plugin::Xslate;

use Moo;
use Carp;
use Text::Xslate;

has app => ( is => 'ro', required => 1 );

has path => ( is => 'ro', lazy => 1, builder => sub {[]} );
has function => ( is => 'ro', lazy => 1, builder => sub {{}} );
has content_type => ( is => 'ro', lazy => 1, builder => sub {
	my ( $self ) = @_;
	my $type = $self->has_type ? $self->type : 'html';
	return 'text/plain' if $type eq 'text';
	return 'text/xml' if $type eq 'xml';
	return 'text/html' if $type eq 'html';
	croak __PACKAGE__." Unknown type ".$type;
} );
has suffix => ( is => 'ro', lazy => 1, builder => sub {'.tx'} );

my @xslate_attributes = qw(
	cache
	cache_dir
	module
	html_builder_module
	input_layer
	verbose
	syntax
	type
	line_start
	tag_start
	tag_end
	header
	footer
	pre_process_handler
);

for (@xslate_attributes) {
	has $_ => ( is => 'ro', predicate => 1 );
}

has xslate => (
	is => 'ro',
	lazy => 1,
	predicate => 1,
	builder => sub {
		my ( $self ) = @_;
		croak __PACKAGE__." Xslate needs at least one path" unless @{$self->path};
		Text::Xslate->new(
			path => $self->path,
			function => $self->all_functions,
			suffix => $self->suffix,
			map {
				my $predicate = 'has_'.$_;
				$self->$predicate ? ( $_ => $self->$_ ) : ()
			} @xslate_attributes,
		);
	},
);

has all_functions => (
	is => 'ro',
	lazy => 1,
	builder => sub {
		my ( $self ) = @_;
		return {
			%{$self->base_functions},
			%{$self->function}
		}
	},
);

has base_functions => (
	is => 'ro',
	lazy => 1,
	builder => sub {
		my ( $self ) = @_;
		return {
			yeb => sub { $self->app },
			app => sub { $self->app },
			cc => sub { $self->app->cc },
			current_context => sub { $self->app->cc },
			current_file => sub { $self->xslate->current_file },
			current_line => sub { $self->xslate->current_line },
			call => sub {
				my ( $thing, $func, @args ) = @_;
				$thing->$func(@args);
			},
			call_if => sub {
				my ( $thing, $func, @args ) = @_;
				$thing->$func(@args) if $thing;
			},
			replace => sub {
				my ( $source, $from, $to ) = @_;
				$source =~ s/$from/$to/g;
				return $source;
			},
			pa => sub {
				my $value = $self->app->cc->request->param(@_);
				defined $value ? $value : "";
			},
			req => sub { $self->app->cc->request },
			env => sub { $self->app->cc->env },
		}
	},
);

sub get_vars {
	my ( $self, $user_vars ) = @_;
	my %stash = %{$self->app->cc->stash};
	my %user_vars = defined $user_vars ? %{$user_vars} : ();
	return {
		%stash,
		%user_vars,
	};
}

sub BUILD {
	my ( $self ) = @_;
	$self->app->register_function('xslate_path',sub {
		croak __PACKAGE__." Xslate already instantiated, no path can be added" if $self->has_xslate;
		unshift @{$self->path}, "$_" for (@_);
	});
	$self->app->register_function('xslate_function',sub {
		croak __PACKAGE__." Xslate already instantiated, no function can be added" if $self->has_xslate;
		my ( $name, $function ) = @_;
		$self->function->{$name} = $function;
	});
	$self->app->register_function('xslate',sub {
		my ( $file, $user_vars ) = @_;
		my $vars = $self->get_vars($user_vars);
		my $template_file = $file.$self->suffix;
		$self->app->cc->content_type($self->content_type);
		$self->app->cc->body($self->xslate->render($template_file,$vars));
		$self->app->cc->response;
	});
}

1;