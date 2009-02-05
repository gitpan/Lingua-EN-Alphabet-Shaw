package Lingua::EN::Alphabet::Shaw;

use 5.005;
use strict;
use warnings;
use utf8;
use Lingua::EN::Phoneme;
our $VERSION = 0.02;

our $lep = new Lingua::EN::Phoneme();

my $i=66640;
our %correspondence = map { $_ => $i++ } qw(
P T K F TH S SH CH Y NG B D G V DH Z ZH JH W HH L M
IH EH AE AH AO UH AW AA R N IY EY AY _up OW UW OY _awe
_are _or _air ER _array
);

# Fixups for the above:
%correspondence = (%correspondence,
		   IH => 66662,
    );

$i = 66680;
our %ligatures = map { chr($_->[0]).chr($_->[1]) => chr($i++) }
(
 [ 66669, 66670 ], # are
 [ 66666, 66670 ], # or
 [ 66663, 66670 ], # air
 [ 66675, 66670 ], # err
 [ 66665, 66670 ], # array
 [ 66662, 66670 ], # ear
 [ 66662, 66665 ], # ian
 [ 66648, 66677 ], # yew
);

our %abbreviations =
(
	AND => chr(66671),
	OF  => chr(66653),
	THE => chr(66654),
	TO  => chr(66641),
);

sub _transliterate_word {
    my ($word) = @_;

    my $abbr = $abbreviations{uc $word};
    return $abbr if $abbr;

    my @pronunciation = $lep->phoneme($word);

    return uc $word unless @pronunciation;

    my $result = '';

    for (@pronunciation) {
	s/[0-9]//g; # don't care about stress
	warn "CMU phoneset $_ does not appear in correspondence"
	    unless $correspondence{$_};
	$result .= chr($correspondence{$_});
    }
    
    for (keys %ligatures) {
    	$result =~ s/$_/$ligatures{$_}/g;
    }

    return $result;
}

sub transliterate {
    my ($sentence) = @_;

    $sentence =~ s/([A-Za-z]+)/_transliterate_word($1)/eg;

    return $sentence;
}

1;

=encoding utf-8
=head1 NAME

Lingua::EN::Alphabet::Shaw - transliterate the Latin to Shavian alphabets

=head1 AUTHOR

Thomas Thurman <tthurman@gnome.org>

=head1 SYNOPSIS

  use Lingua::EN::Alphabet;

  print Lingua::EN::Alphabet::Shavian::transliterate("badger");
  # prints "𐑚𐑨𐑡𐑻"

=head1 DESCRIPTION

The Shaw or Shavian alphabet was commissioned by the will of the playwright
George Bernard Shaw in the early 1960s as a replacement for the Latin
alphabet for representing English.  It is designed to have a one-to-one
phonemic (not phonetic) mapping with the sounds of English.

Its ISO 15924 code is "Shaw" 281.

This module transliterates English text from the Latin alphabet into the
Shavian alphabet.

𐑞 𐑖𐑪 𐑹 ·𐑖𐑱𐑝𐑾𐑯 𐑨𐑤𐑓𐑩𐑚𐑧𐑑 𐑢𐑭𐑟 𐑒𐑩𐑥𐑦𐑖𐑩𐑯𐑛 𐑚𐑲 𐑞 𐑢𐑦𐑤 𐑝 𐑞 𐑐𐑤𐑱𐑮𐑲𐑑 ·𐑡𐑹𐑡
·𐑚𐑻𐑯𐑸𐑛 ·𐑖𐑪 𐑦𐑯 𐑞 𐑻𐑤𐑰 1960𐑟 𐑨𐑟 𐑩 𐑮𐑦𐑐𐑤𐑱𐑕𐑥𐑩𐑯𐑑 𐑓𐑹 𐑞 𐑤𐑨𐑑𐑩𐑯 𐑨𐑤𐑓𐑩𐑚𐑧𐑑
𐑓𐑹 𐑮𐑧𐑐𐑮𐑦𐑟𐑧𐑯𐑑𐑦𐑙 𐑦𐑙𐑜𐑤𐑦𐑖. 𐑦𐑑 𐑦𐑟 𐑛𐑦𐑟𐑲𐑯𐑛 𐑑 𐑣𐑨𐑝 𐑩 𐑢𐑩𐑯-𐑑-𐑢𐑩𐑯 𐑓𐑩𐑯𐑰𐑥𐑦𐑒 (𐑯𐑭𐑑
𐑓𐑩𐑯𐑧𐑑𐑦𐑒) 𐑥𐑨𐑐𐑦𐑙 𐑢𐑦𐑞 𐑞 𐑕𐑬𐑯𐑛𐑟 𐑝 𐑦𐑙𐑜𐑤𐑦𐑖.

𐑦𐑑𐑕 ISO 15924 𐑒𐑴𐑛 𐑦𐑟 "Shaw" 281.

𐑞𐑦𐑕 𐑥𐑭𐑡𐑵𐑤 𐑑𐑮𐑨𐑯𐑟𐑤𐑦𐑑𐑻𐑱𐑑𐑕 𐑦𐑙𐑜𐑤𐑦𐑖 𐑑𐑧𐑒𐑕𐑑 𐑓𐑮𐑩𐑥 𐑞 𐑤𐑨𐑑𐑩𐑯 𐑨𐑤𐑓𐑩𐑚𐑧𐑑 𐑦𐑯𐑑𐑵 𐑞
·𐑖𐑱𐑝𐑾𐑯  𐑨𐑤𐑓𐑩𐑚𐑧𐑑.

=head1 METHODS

=head2 transliterate($latin)

Returns the transliteration of the given word into the Shavian alphabet.
If the word is not in the dictionary, returns $latin in uppercase.

𐑮𐑦𐑑𐑻𐑯𐑟 𐑞 𐑑𐑮𐑨𐑯𐑟𐑤𐑦𐑑𐑻𐑱𐑠𐑩𐑯 𐑝 𐑞 𐑜𐑦𐑝𐑩𐑯 𐑢𐑻𐑛 𐑦𐑯𐑑𐑵 𐑞 ·𐑖𐑱𐑝𐑾𐑯 𐑨𐑤𐑓𐑩𐑚𐑧𐑑. 𐑦𐑓 𐑞 𐑢𐑻𐑛
𐑦𐑟 𐑯𐑭𐑑 𐑦𐑯 𐑞 𐑛𐑦𐑒𐑖𐑩𐑯𐑺𐑰, 𐑮𐑦𐑑𐑻𐑯𐑟 $latin 𐑦𐑯 𐑩𐑐𐑻𐑒𐑱𐑕. 

=head1 FONTS

You will need a Shavian Unicode font to use this module.
There are several such fonts at http://marnanel.org/shavian/fonts/ .
Please be sure to get a Unicode font and not one with the "Latin mapping".

𐑿 𐑢𐑦𐑤 𐑯𐑰𐑛 𐑩 ·𐑖𐑱𐑝𐑾𐑯 ·𐑿𐑯𐑰𐑒𐑴𐑛 𐑓𐑭𐑯𐑑 𐑑 𐑿𐑕 𐑞𐑦𐑕 𐑥𐑭𐑡𐑵𐑤.
𐑞𐑺 𐑸 𐑕𐑧𐑝𐑮𐑩𐑤 𐑕𐑩𐑗 𐑓𐑭𐑯𐑑𐑕 𐑨𐑑 http://marnanel.org/shavian/fonts/ .
𐑐𐑤𐑰𐑟 𐑚𐑰 𐑖𐑫𐑮 𐑑 𐑜𐑧𐑑 𐑩 ·𐑿𐑯𐑰𐑒𐑴𐑛 𐑓𐑭𐑯𐑑 𐑯 𐑯𐑭𐑑 𐑢𐑩𐑯 𐑢𐑦𐑞 𐑞 "·𐑤𐑨𐑑𐑩𐑯 𐑥𐑨𐑐𐑦𐑙". 

=head1 BUGS

The dictionary is quite small.

The vowels don't match exactly to those used in "Androcles and the Lion",
since they are restricted by the vowel set used in cmudict.  For the same
reason, a few of the Shavian vowels cannot ever be produced: Shavian simply
makes some vowel distinctions which cmudict does not.  If you think some
of the mappings I have made are incorrect, please let me know.

The naming dot is not yet supported.

𐑞 𐑛𐑦𐑒𐑖𐑩𐑯𐑺𐑰 𐑦𐑟 𐑒𐑢𐑲𐑑 𐑕𐑥𐑪𐑤.

𐑞 𐑝𐑬𐑩𐑤𐑟 𐑛𐑴𐑯'𐑑 𐑥𐑨𐑗 𐑦𐑜𐑟𐑨𐑒𐑑𐑤𐑰 𐑑 𐑞𐑴𐑟 𐑿𐑟𐑛 𐑦𐑯 "·𐑨𐑯𐑛𐑮𐑩𐑒𐑤𐑰𐑟 𐑯 𐑞 𐑤𐑲𐑩𐑯",
𐑕𐑦𐑯𐑕 𐑞𐑱 𐑸 𐑮𐑰𐑕𐑑𐑮𐑦𐑒𐑑𐑩𐑛 𐑚𐑲 𐑞 𐑝𐑬𐑩𐑤 𐑕𐑧𐑑 𐑿𐑟𐑛 𐑦𐑯 cmudict. 𐑓𐑹 𐑞 𐑕𐑱𐑥 𐑮𐑰𐑟𐑩𐑯,
𐑩 𐑓𐑿 𐑝 𐑞 ·𐑖𐑱𐑝𐑾𐑯 𐑝𐑬𐑩𐑤𐑟 𐑒𐑨𐑯𐑭𐑑 𐑧𐑝𐑻 𐑚𐑰 𐑐𐑮𐑩𐑛𐑵𐑕𐑑: ·𐑖𐑱𐑝𐑾𐑯 𐑕𐑦𐑥𐑐𐑤𐑰 𐑥𐑱𐑒𐑕
𐑕𐑩𐑥 𐑝𐑬𐑩𐑤 𐑛𐑦𐑕𐑑𐑦𐑙𐑒𐑖𐑩𐑯𐑟 𐑢𐑦𐑗 cmudict 𐑛𐑩𐑟 𐑯𐑭𐑑. 𐑦𐑓 𐑿 𐑔𐑦𐑙𐑒 𐑕𐑩𐑥 𐑝 𐑞
𐑥𐑨𐑐𐑦𐑙𐑟  𐑲 𐑣𐑨𐑝 𐑥𐑱𐑛 𐑸 𐑦𐑯𐑒𐑻𐑧𐑒𐑑, 𐑐𐑤𐑰𐑟 𐑤𐑧𐑑 𐑥𐑰 𐑯𐑴.

𐑞 𐑯𐑱𐑥𐑦𐑙 𐑛𐑭𐑑 𐑦𐑟 𐑯𐑭𐑑 𐑘𐑧𐑑 𐑕𐑩𐑐𐑹𐑑𐑩𐑛. 

=head1 COPYRIGHT

This Perl module is copyright (C) Thomas Thurman, 2009.
This is free software, and can be used/modified under the same terms as
Perl itself.

𐑞𐑦𐑕 𐑐𐑻𐑤 𐑥𐑭𐑡𐑵𐑤 𐑦𐑟 𐑒𐑭𐑐𐑰𐑮𐑲𐑑 (C) 𐑑𐑭𐑥𐑩𐑕 𐑔𐑻𐑥𐑩𐑯, 2009.
𐑞𐑦𐑕 𐑦𐑟 𐑓𐑮𐑰 𐑕𐑪𐑓𐑑𐑢𐑺, 𐑯 𐑒𐑨𐑯 𐑚𐑰 𐑿𐑟𐑛/𐑥𐑭𐑛𐑩𐑓𐑲𐑛 𐑩𐑯𐑛𐑻 𐑞 𐑕𐑱𐑥 𐑑𐑻𐑥𐑟 𐑨𐑟 𐑐𐑻𐑤 𐑦𐑑𐑕𐑧𐑤𐑓. 
