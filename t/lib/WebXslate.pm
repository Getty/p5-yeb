package WebXslate;

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
	xslate 'index/test';
};

1;