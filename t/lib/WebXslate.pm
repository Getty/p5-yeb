package WebXslate;

use Yeb;

BEGIN {
	plugin 'Session';
	plugin 'JSON';
	plugin 'Xslate';
	plugin 'Static';
}

xslate_path root('templates');

static qr{^/}, root('htdocs');
static_404 qr{^/images/}, root('htdocs');

r "/" => sub {
	st->{page} = 'root';
	xslate 'index';
};

r "/test" => sub {
	st->{page} = 'test';
	xslate 'index/test';
};

1;