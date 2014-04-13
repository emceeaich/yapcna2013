#!/user/bin/env perl
use Mojolicious::Lite;

# We'll define some data here that our API will return

my $data = {
    1 => {title => q(Jane's Talk),     boring=>1, length=>2.0 },
    2 => {title => q(Elane's Talk),    boring=>0, length=>1.0 },
    3 => {title => q(Gilbert's Talk),  boring=>1, length=>0.5 },
    4 => {title => q(Humberto's Talk), boring=>0, length=>1.0 },
    5 => {title => q(Ameera's Talk),   boring=>0, length=>1.0 },
    6 => {title => q(Xue's Talk),      boring=>1, length=>0.25}
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
    $self->render(json => { collection => $wanted  });
};

# a request to /api/item/:id returns one of the hashes in $data, 
# as long as the index is in bounds
# otherwise return a 404 response

get '/api/item/:id' => sub {
    my $self = shift;
    my $id   = int $self->param('id');
    my $size = scalar (keys %$data);
    my $prev = $id - 1;
    if ($prev < 1) {
      $prev = $size;
    }

    if (exists $data->{$id}) {
      my $hash = $data->{$id};
      $hash->{id} = $id;
      $hash->{next} = ($id % $size) + 1;
      $hash->{prev} = $prev;
      $self->render(json => $hash);
    }
    else {
      $self->render(json => {error => "Not Found"}, status => 404);
    }
};

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
<noscript>This Application Requires JavaScript.</noscript>
<h1>Schedule</h1>
<div id="content">
Loading...
</div>
<script src="/lib/jquery/jquery.min.js"></script>
<script src="/lib/mustache/mustache.js"></script>
<script src="/lib/underscore/underscore.js"></script>
<script src="/lib/backbone/backbone.js"></script>
<script src="/app.js"></script>
</body>
</html>
