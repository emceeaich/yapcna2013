#!/user/bin/env perl
use strict;
use Mojolicious::Lite;

# We'll define some data here that our API will return

my $data = {
    1 => {title => q(Jane's Talk),     boring=>1, length=>2.0 },
    2 => {title => q(Elane's Talk),    boring=>0, length=>1.0 },
    3 => {title => q(Gilbert's Talk),  boring=>1, length=>0.5 },
    4 => {title => q(Humberto's Talk), boring=>1, length=>1.0 },
    5 => {title => q(Ameera's Talk),   boring=>1, length=>1.0 }
};

# routes

get '/' => 'index'; # the default route returns the template defined below

# a request to /api/item returns JSON with the property 
# collection assigned to the serialization of $data

get '/api/item' => sub {
    my $self = shift;
    my $wanted = [
        map { { 'id' => $_,
                'title' => $data->{$_}->{title} } }
        keys %$data
    ];
    $self->render_json( { collection => $wanted  } );
};

# a request to /api/item/:id returns one of the hashes in $data, 
# as long as the index is in bounds
# otherwise return a 404 response

get '/api/item/:id' => sub {
    my $self = shift;
    my $id   = int $self->param('id');

    if (exists $data->{$id}) {
    	my $hash = $data->{$id};
        $hash->{id} = $id;
    	$self->render(json => $hash);
    }
    else {
	   $self->render(json => {error => "Not Found"}, status => 404);
    }
};

app->secret('welcome to the clown car, bro');
app->start;
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html lang="en">
<head>
<title>Backbone/Mojolicous Example</title>
<link rel="stylesheet" href="/app.css">
</head>
<body>
<h1>Schedule</h1>
<div id="content">
Loading...
</div>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/mustache.js/0.7.2/mustache.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/backbone.js/1.0.0/backbone-min.js"></script>
<script src="/app.js"></script>
</body>
</html>
