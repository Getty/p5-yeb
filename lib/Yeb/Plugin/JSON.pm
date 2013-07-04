package Yeb::Plugin::JSON;

use Moo;
use JSON;

has app => ( is => 'ro', required => 1 );

sub BUILD {
	my ( $self ) = @_;
	$self->app->register_function('json',sub {
		my $data = shift;
		$data = $self->app->current_context->stash->{x} unless defined $data;
		$self->app->current_context->content_type('application/json');
		$self->app->current_context->body(to_json($data,@_));
		$self->app->current_context->response;
	});
}

1;