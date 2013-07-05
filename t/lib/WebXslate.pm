package WebXslate;

use Yeb;

BEGIN {
	plugin 'Session';
	plugin 'JSON';
	plugin 'Xslate';
	plugin 'Static', default_root => root('htdocs');
}

xslate_path root('templates');

static qr{^/};
static_404 qr{^/images/}, root('htdocs');

r "/" => sub {
	st page => 'root';
	xslate 'index';
};

r "/test" => sub {
	st page => 'test';
	xslate 'index/test';
};

r "/json" => sub {
  ex key => 'value';
  json { other_key => 'value' };
};

1;