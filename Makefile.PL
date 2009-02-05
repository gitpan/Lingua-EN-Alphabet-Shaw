use inc::Module::Install;
  
name           'Lingua-EN-Alphabet-Shaw';
all_from       'lib/Lingua/EN/Alphabet/Shaw.pm';

requires       'Lingua::EN::Phoneme';

WriteAll;
