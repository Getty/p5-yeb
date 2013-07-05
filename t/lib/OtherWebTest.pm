package OtherWebTest;

use Yeb;

r "/" => sub {
	text "other root";
};

r "/a" => sub {
	text "other a";
};

1;