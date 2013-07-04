package Yeb;
# ABSTRACT: Yeb another web framework! Yeb Yeb!

use strict;
use warnings;

use Yeb::Application;

sub import { shift; Yeb::Application->new(
	class => caller,
	@_ ? ( args => [@_] ) : (),
)}

1;
