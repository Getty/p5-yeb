package OtherWebTest;

use Yeb;

r "/" => sub {
	text "other root";
};

r "/a" => sub {
	text "other a";
};

r "/crash" => sub {
	my $yeb = yeb();
	# BEGIN {
	# 	use Package::Stash;
	# 	use Data::Dumper;
	# 	print Dumper [Package::Stash->new(__PACKAGE__)->list_all_symbols];
	# }
	json {};
};

1;