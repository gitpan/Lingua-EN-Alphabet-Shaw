package Lingua::EN::Alphabet::Shaw;

use 5.005;
use strict;
use warnings;
use DBI;
use Encode;
use File::ShareDir qw(dist_file);

our $VERSION = 0.51;

sub new {
    my ($class) = @_;
    my $self = {
	dbh => undef,
	sth => undef,
	map => undef,
    };
    return bless($self, $class);
}

sub transliterate {
    my ($self, $text) = @_;

    unless (defined $self->{dbh}) {
	my $filename;

	# allow a local override
	$filename = glob('~/.cache/shavian/shavian-set.sqlite');
	$filename = dist_file('Lingua-EN-Alphabet-Shaw', 'shavian-set.sqlite') unless -e $filename;

	$self->{dbh} = DBI->connect("dbi:SQLite:dbname=$filename","","");
	$self->{sth} = $self->{dbh}->prepare('select shaw, pos, dab from words where latn=?');
    }

    my $prevpos = 'n'; # sensible default

    my $lookup_word = sub {
	my ($word) = @_;

	$self->{sth}->execute(lc $word);
	my $homonyms = $self->{sth}->fetchall_arrayref();
	return $word unless @$homonyms;
	my $candidate = $homonyms->[0];
	for (@$homonyms) {
	    $candidate = $_ if $_->[2] =~ $prevpos;
	    $candidate = $_ if $_->[2] eq 'g' && $word =~ /^[A-Z]/;
	    $candidate = $_ if $_->[2] eq 'h' && $word =~ /^[a-z]/;
	}

	$prevpos = $candidate->[1];
	return decode_utf8($candidate->[0]);
    };

    $text =~ s/(?<!%)(?<!\\)\b([a-z]|[a-z][a-z']*[a-z])\b/$lookup_word->($1)/ieg;

    return $text;
}

sub mapping {

    my ($self, $text) = @_;

    unless (defined $self->{map}) {
	$self->{map} = {};
	my $codepoint = 66640;
	for (qw(p t k f T s S c j N b d g v H z
                Z J w h l m i e A a o U Q y r n
                I E F u O M q Y R P X x D C W V)) {
	    $self->{map}->{chr($codepoint)} = $_;
	    $self->{map}->{$_} = chr($codepoint);
	    $codepoint++;
	}

	my $naming_dot = chr(0xB7);
	$self->{map}->{$naming_dot} = 'G';
	$self->{map}->{'G'} = $naming_dot;
	$self->{map}->{'B'} = $naming_dot;
	# some standards also map it to the solidus
	# but that will stop this function being
	# its own inverse
    }

    my $remap = sub {
	my ($char) = @_;
	return $self->{map}->{$char} if defined $self->{map}->{$char};
	return $char;
    };

    $text =~ s/(.)/$remap->($1)/ge;
    return $text;
}

sub DESTROY {
    my ($self) = @_;

    $self->{sth}->finish() if defined $self->{sth};
}

1;
=head1 NAME

Lingua::EN::Alphabet::Shaw - transliterate the Latin to Shavian alphabets

=head1 AUTHOR

Thomas Thurman <tthurman@gnome.org>

=head1 SYNOPSIS

  use Lingua::EN::Alphabet::Shaw;

  my $shaw = Lingua::EN::Alphabet::Shaw->new();
  print $shaw->transliterate('I live near a live wire.');

=head1 DESCRIPTION

The Shaw or Shavian alphabet was commissioned by the will of the playwright
George Bernard Shaw in the early 1960s as a replacement for the Latin
alphabet for representing English.  It is designed to have a one-to-one
phonemic (not phonetic) mapping with the sounds of English.

Its ISO 15924 code is "Shaw" 281.

This module transliterates English text from the Latin alphabet into the
Shavian alphabet.

The API has changed since version 0.03 to be object-based.

If you find an error in the translation database, you can change it
yourself at http://shavian.org.uk/wiki/ .  If you want to override the
database shipped with this module, place the new copy at
~/.shavian/shavian-set.sqlite and it will be used in preference.

=head1 METHODS

=head2 Lingua::EN::Alphabet::Shaw->new()

Constructor.  Currently takes no arguments.

=head2 $shaw->transliterate($phrase)

Returns the transliteration of the given phrase into the Shavian alphabet.
Can handle multi-word phrases.  Does a reasonable job resolving homonym
ambiguity ("does he like does?").

=head2 $shaw->mapping($phrase)

There is a quasi-standard mapping of the Latin alphabet onto the Shavian
alphabet.  This method maps Shavian text into Latin and vice versa.
It does not transliterate.  Think of this as a kind of ASCII-armouring.

=head1 BUGS

It should probably be possible to transliterate from Shavian to the
conventional alphabet.

It should be possible to handle other alternative scripts, such as
Deseret and Tengwar.

The portion of the database which is taken from CMUdict exhibits
unhelpful mergers (notably father/bother).

=head1 FONTS

You will need a Shavian Unicode font to use this module.
There are several such fonts at http://marnanel.org/shavian/fonts/ .
Please be sure to get a Unicode font and not one with the "Latin mapping".

However, the Mac can handle the Shavian alphabet out of the box.

=head1 COPYRIGHT

This Perl module is copyright (C) Thomas Thurman, 2009-2010.
This is free software, and can be used/modified under the same terms as
Perl itself.

The transliteration data is available under various free licences,
which are reproduced below.

=head1 LICENCES

=head2 Shavian Wiki

Part of the transliteration data was taken from the Shavian Wiki, and
this is available under the Creative Commons cc-by-sa licence.

=head2 CMUdict

Another part of the transliteration data was taken from CMUdict.  Its
licence is reproduced below.

Copyright (C) 1993-2008 Carnegie Mellon University. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
   The contents of this file are deemed to be source code.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

This work was supported in part by funding from the Defense Advanced
Research Projects Agency, the Office of Naval Research and the National
Science Foundation of the United States of America, and by member
companies of the Carnegie Mellon Sphinx Speech Consortium. We acknowledge
the contributions of many volunteers to the expansion and improvement of
this dictionary.

THIS SOFTWARE IS PROVIDED BY CARNEGIE MELLON UNIVERSITY ``AS IS'' AND
ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
NOR ITS EMPLOYEES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=head2 Brown tagger

The part-of-speech data was taken from the Brown tagger (although the
tagger built into this model is not the Brown tagger, so its first
sentence is inaccurate).  Its licence is also reproduced below:

This software was written by Eric Brill.

This software is being provided to you, the LICENSEE, by the 
Massachusetts Institute of Technology (M.I.T.) under the following 
license.  By obtaining, using and/or copying this software, you agree 
that you have read, understood, and will comply with these terms and 
conditions:  

Permission to [use, copy, modify and distribute, including the right to 
grant others rights to distribute at any tier, this software and its 
documentation for any purpose and without fee or royalty] is hereby 
granted, provided that you agree to comply with the following copyright 
notice and statements, including the disclaimer, and that the same 
appear on ALL copies of the software and documentation, including 
modifications that you make for internal use or for distribution:

Copyright 1993 by the Massachusetts Institute of Technology and the
University of Pennsylvania.  All rights reserved.  

THIS SOFTWARE IS PROVIDED "AS IS", AND M.I.T. MAKES NO REPRESENTATIONS 
OR WARRANTIES, EXPRESS OR IMPLIED.  By way of example, but not 
limitation, M.I.T. MAKES NO REPRESENTATIONS OR WARRANTIES OF 
MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE OR THAT THE USE OF 
THE LICENSED SOFTWARE OR DOCUMENTATION WILL NOT INFRINGE ANY THIRD PARTY 
PATENTS, COPYRIGHTS, TRADEMARKS OR OTHER RIGHTS.   

The name of the Massachusetts Institute of Technology or M.I.T. may NOT 
be used in advertising or publicity pertaining to distribution of the 
software.  Title to copyright in this software and any associated 
documentation shall at all times remain with M.I.T., and USER agrees to 
preserve same.  
