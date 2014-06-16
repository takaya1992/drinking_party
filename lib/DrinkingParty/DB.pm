package DrinkingParty::DB;
use DBIx::Skinny connect_info => +{
    dsn => 'dbi:SQLite:dbname=db/answers.db',
    username => '',
    password => ''
};
1;
