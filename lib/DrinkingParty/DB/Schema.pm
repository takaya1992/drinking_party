package DrinkingParty::DB::Schema;
use DBIx::Skinny::Schema;
    
install_table user => schema {
  pk 'id';
  columns qw/
    id
    team_id
    answer_number
    image_url
  /;
};
1;
