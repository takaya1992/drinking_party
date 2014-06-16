package DrinkingParty::Answer;
use strict;
use warnings;

use Data::Dumper;

use parent qw/Class::Accessor::Fast/;

__PACKAGE__->mk_accessors(qw/
  id
  team_id
  answer_number
  image_url
/);


1;
