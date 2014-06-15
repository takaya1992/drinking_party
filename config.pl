+{
  DBI => [
    'dbi:SQLite:./answer.db',
    '',
    '',
    {sqlite_unicode => 1},
  ],
  tables => {
    foo => { 
      fields => ['*'],
      options => {
        order_by => 'id',
        limit => 10,
      },
    },
  },
}
