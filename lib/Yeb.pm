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
    st->{blub} = 1;
    text "root";
  };

  r "/test/..." => sub {
    chain 'Test';
  };

  1;

  package MyApp::Web::Test;
  use MyApp::Web;

  r "/json" => sub {
    json {
      test => session->{test},
      blub => st->{blub} ? 1 : 0,
    }
  };

  r "/" => sub {
    text " test = ".session->{test}." and blub is ".st->{blub} ? 1 : 0;
  };

  1;

Can then be started like (see L<Web::Simple>):

  plackup -MMyApp::Web -e'MyApp::Web->run_if_script'

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


