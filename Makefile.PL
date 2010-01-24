use inc::Module::Install;
  
name           'Lingua-EN-Alphabet-Shaw';
all_from       'lib/Lingua/EN/Alphabet/Shaw.pm';

requires       'DBI';
requires       'File::ShareDir';

install_share;

WriteAll;
