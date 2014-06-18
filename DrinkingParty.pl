#!/usr/bin/env perl
use Mojolicious::Lite;
use File::Spec;
use File::Basename 'basename';
use File::Path 'mkpath';
use DrinkingParty::DB;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

my $IMAGE_BASE = 'upload/images';
my $IMAGE_DIR  = app->home->rel_file('/public') . '/';
unless (-d $IMAGE_DIR . $IMAGE_BASE) {
  mkpath $IMAGE_DIR . $IMAGE_BASE or die "Cannot create dirctory: $IMAGE_DIR $IMAGE_BASE";
}

my $skinny = DrinkingParty::DB->new;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

get '/reset' => sub {
  my $self = shift;
  $skinny->delete('answer');
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

  my $image_file = "$IMAGE_BASE/" . create_filename(). ".png";
  while (-f ($IMAGE_DIR . $image_file)) {
    $image_file = "$IMAGE_BASE/" . create_filename() . ".png";
  }

  $image->move_to($IMAGE_DIR . $image_file);

  $self->app->log->debug('team_id = ' . $team_id);
  $self->app->log->debug('image_number = ' . $image_number);
  $self->app->log->debug('image_file = ' . $image_file);

  my $row = $skinny->insert('answer',
    {
      team_id       => $team_id,
      answer_number => $image_number,
      image_url     => $image_file,
      marked        => 0
    }
  );
      

  $self->res->code(200);
  $self->render(text => 'success');
};

get '/answer' => sub {
  my $self = shift;

  #my $marked = ($self->param('marked') eq 0) ? 0 : 1;

  my $answers = {};
  my @teams = qw/A B C/;
  foreach my $team (@teams) {
    #my @rows = $skinny->search('answer', {team_id => $team, marked => $marked}, {order_by => 'answer_number'});
    my @rows = $skinny->search('answer', {team_id => $team}, {order_by => 'answer_number'});
    my $_answers = [];
    foreach my $row (@rows) {
      push $_answers, $row->{row_data};
    }
    $answers->{$team} = $_answers;
  }
  $self->res->code(200);
  $self->render(json => $answers);
};

get '/test/upload' => sub {
  my $self = shift;
  $self->render('test/upload');
};


get '/answer/mark' => sub {
  my $self = shift;
  $self->render('answer/mark');
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
