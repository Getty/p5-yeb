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
    session->{test} = pa('test');
    text "root";
  };

  r "/blub" => sub {
    text "blub";
  };

  r "/test/..." => sub {
    st->{stash_var} = 1;
    chain 'Test';
  };

  1;

  package MyApp::Web::Test;
  use MyApp::Web;

  r "/json" => sub {
    json {
      test => session->{test},
      stash_var => st->{stash_var},
    }
  };

  r "/" => sub {
    text " test = ".session->{test}." and blub is ".st->{stash_var};
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
  }

  xslate_path root('templates');

  r "/" => sub {
    st->{page} = 'root';
    xslate 'index';
  };

  r "/test" => sub {
    st->{page} = 'test';
    xslate 'index/test', { extra_var => 'extra' };
  };

  1;

=head1 DESCRIPTION

Just.... had to be done...

=head1 SUPPORT

IRC

  Join #web-simple on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-yeb
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-yeb/issues


