#!/usr/bin/env perl
use Mojolicious::Lite;
use File::Basename 'basename';
use File::Path 'mkpath';
use DrinkingParty::DB;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

my $IMAGE_BASE = '/upload/images';
my $IMAGE_DIR  = app->home->rel_file('/public') . $IMAGE_BASE;
unless (-d $IMAGE_DIR) {
  mkpath $IMAGE_DIR or die "Cannot create dirctory: $IMAGE_DIR";
}



get '/' => sub {
  my $self = shift;
  $self->render('index');
};

get '/reset' => sub {
  my $self = shift;
  $self->render(json => {
    result => 'success'
  });
};

post '/answer' => sub {
  my $self = shift;
  my $team_id      = $self->req->param('team_id');
  my $image_number = $self->req->param('image_number');
  my $image        = $self->req->upload('image');
  # Check file type
  my $image_type = $image->headers->content_type;
  unless ($image_type eq 'image/png') {
    $self->res->code(400);
    return $self->render(json => {
      error => {
        code    => 100,
        message => 'content type is not "image/png".'
      }
    });
  }

  my $image_file = "$IMAGE_DIR/" . create_filename(). ".png";
  while (-f $image_file) {
    $image_file = "$IMAGE_DIR/" . create_filename() . ".png";
  }

  $image->move_to($image_file);

  $self->app->log->debug('team_id = ' . $team_id);
  $self->app->log->debug('image_number = ' . $image_number);
  $self->app->log->debug('image_file = ' . $image_file);

  my $skinny = DrinkingParty::DB->new;
  my $row = $skinny->insert('answer',
    {
      id           => 1,
      team_id      => $team_id,
      answer_number => $image_number,
      image_url    => $image_file
    }
  );
      

  $self->res->code(200);
  $self->render(text => 'success');
};

get '/answer' => sub {


};

get '/test/upload' => sub {
  my $self = shift;
  $self->render('test/upload');
};


# Create filename like image-20091014051023-78973
sub create_filename {
  my ($sec, $min, $hour, $mday, $month, $year) = localtime;
  $month = $month + 1;
  $year = $year + 1900;
  my $rand_num = int(rand 100000);
  return sprintf(
    "image-%04s%02s%02s%02s%02s%02s-%05s",
    $year,
    $month,
    $mday,
    $hour,
    $min,
    $sec,
    $rand_num
  );
}

app->start;
