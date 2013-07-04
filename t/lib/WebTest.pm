package WebTest;

use Yeb;

route "/" => sub { text "root" };

route "/blub/..." => sub { chain 'WebTest::Bla' };

1;