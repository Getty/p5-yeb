package Yeb;
# ABSTRACT: Yep! Yeb is for web! Yep Yep!

use strict;
use warnings;

use Yeb::Application;

sub import { shift; Yeb::Application->new(
	class => caller,
	@_ ? ( args => [@_] ) : (),
)}

1;

=encoding utf8

=head1 SYNOPSIS

  package MyApp::Web;
  use Yeb;

  BEGIN {
    plugin 'Session';
    plugin 'JSON';
  }

  r "/" => sub {
    session test => pa('test');
    text "root";
  };

  r "/blub" => sub {
    text "blub";
  };

  r "/test/..." => sub {
    st stash_var => 1;
    chain 'Test';
  };

  1;

  package MyApp::Web::Test;
  use MyApp::Web;

  r "/json" => sub {
    json {
      test => session('test'),
      stash_var => st('stash_var'),
    }
  };

  r "/" => sub {
    text " test = ".session('test')." and blub is ".st('stash_var');
  };

  1;

Can then be started like (see L<Web::Simple>):

  plackup -MMyApp::Web -e'MyApp::Web->run_if_script'

Or a L<Text::Xslate> example:

  package MyApp::WebXslate;

  use Yeb;

  BEGIN {
    plugin 'Session';
    plugin 'JSON';
    plugin 'Xslate';
    plugin 'Static', default_root => root('htdocs');
  }

  xslate_path root('templates');

  static qr{^/};
  static_404 qr{^/images/}, root('htdocs_images');

  r "/" => sub {
    st page => 'root';
    xslate 'index';
  };

  r "/test" => sub {
    st->{page} = 'test';
    xslate 'index/test', { extra_var => 'extra' };
  };

  1;

=head1 DESCRIPTION

=head1 PLUGINS

For an example on how to make a simple plugin, which adds a new function and
uses a L<Plack::Middleware>, please see the source of L<Yeb::Plugin::Session>.

=head1 FRAMEWORK FUNCTIONS

=head2 yeb

Gives back the L<Yeb::Application> of the web application

=head2 chain

Return another class dispatcher chain, will be prepend with your main class
name, this can be deactivated by using a B<+> in front of the class name.

=head2 cfg

Access to the configuration hash

=head2 cc

Getting the current L<Yeb::Context> of the request

=head2 env

Getting the Plack environment

=head2 req

Getting the current L<Plack::Request>

=head2 root

Current directory or B<YEB_ROOT> environment variable

=head2 cur

Current directory in the moment of start

=head2 plugin $yeb_plugin_name, { key => $value };

=head2 st

Access to the stash hash

=head2 pa

Access to the request parameters, gives back "" if is not set

=head2 pa_has

Check if some parameter is at all set

=head2 r

Adding a new dispatcher for this class (see L<Web::Simple>)

=head2 middleware

Adding a L<Plack::Middleware> to the flow

=head2 text

Make a simple B<text/plain> response with the text given as parameter

=head1 SEE ALSO

=over 4

=item L<Yeb::Plugin::Session>

Session management via L<Plack::Middleware::Session>

=item L<Yeb::Plugin::Static>

Static files via L<Plack::Middleware::Static>

=item L<Yeb::Plugin::Xslate>

Template output via L<Text::Xslate>

=item L<Yeb::Plugin::JSON>

JSON output via L<JSON>

=back

=head1 SUPPORT

IRC

  Join #web-simple on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-yeb
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-yeb/issues


