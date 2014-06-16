package DrinkingParty::DB::Schema;
use DBIx::Skinny::Schema;
    
install_table answer => schema {
  pk 'id';
  columns qw/
    id
    team_id
    answer_number
    image_url
  /;
};
1;
