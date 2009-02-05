use strict;
use warnings;
use Lingua::EN::Alphabet::Shaw;
use Test::More;
use utf8;

binmode DATA, ':utf8';
binmode STDOUT, ':utf8';

my @lines;
while (<DATA>) {
	chomp;
	push @lines, $_;
}

if (0) {
	# use this to generate test data
	while (@lines) {
		my $latin = shift @lines;
		shift @lines;
		
		print "$latin\n".
		Lingua::EN::Alphabet::Shaw::transliterate($latin)."\n";
	}
	exit;
}

plan tests => (scalar(@lines))/2;

while (@lines) {
	my $latin = shift @lines;
	my $shavian = shift @lines;

	is (Lingua::EN::Alphabet::Shaw::transliterate($latin),
		$shavian, $latin);
}

# Note that the Shavian text is not identical to that published in the
# Shaw Alphabet Edition of the book, since the use of vowels is inconsistent
# between that work and the CMU Pronouncing Dictionary.
# Also, some of the words are clearly missing.
__DATA__
Overture: forest sounds, roaring of lions, Christian hymn faintly.
𐑴𐑝𐑻𐑗𐑻: 𐑓𐑹𐑩𐑕𐑑 𐑕𐑬𐑯𐑛𐑟, 𐑮𐑹𐑦𐑙 𐑝 𐑤𐑲𐑩𐑯𐑟, 𐑒𐑮𐑦𐑕𐑗𐑩𐑯 𐑣𐑦𐑥 𐑓𐑱𐑯𐑑𐑤𐑰.
A jungle path.
𐑩 𐑡𐑩𐑙𐑜𐑩𐑤 𐑐𐑨𐑔.
A lion's roar, a melancholy suffering roar, comes from the jungle.
𐑩 𐑤𐑲𐑩𐑯'𐑧𐑕 𐑮𐑹, 𐑩 𐑥𐑧𐑤𐑩𐑯𐑒𐑭𐑤𐑰 𐑕𐑩𐑓𐑻𐑦𐑙 𐑮𐑹, 𐑒𐑩𐑥𐑟 𐑓𐑮𐑩𐑥 𐑞 𐑡𐑩𐑙𐑜𐑩𐑤.
It is repeated nearer. The lion limps from the jungle on three legs,
𐑦𐑑 𐑦𐑟 𐑮𐑦𐑐𐑰𐑑𐑦𐑛 𐑯𐑽𐑻. 𐑞 𐑤𐑲𐑩𐑯 𐑤𐑦𐑥𐑐𐑕 𐑓𐑮𐑩𐑥 𐑞 𐑡𐑩𐑙𐑜𐑩𐑤 𐑭𐑯 𐑔𐑮𐑰 𐑤𐑧𐑜𐑟,
holding up his right forepaw, in which a huge thorn sticks.
𐑣𐑴𐑤𐑛𐑦𐑙 𐑩𐑐 𐑣𐑦𐑟 𐑮𐑲𐑑 FOREPAW, 𐑦𐑯 𐑢𐑦𐑗 𐑩 𐑣𐑿𐑡 𐑔𐑹𐑯 𐑕𐑑𐑦𐑒𐑕.
He sits down and contemplates it. He licks it.
𐑣𐑰 𐑕𐑦𐑑𐑕 𐑛𐑬𐑯 𐑯 𐑒𐑭𐑯𐑑𐑩𐑥𐑐𐑤𐑱𐑑𐑕 𐑦𐑑. 𐑣𐑰 𐑤𐑦𐑒𐑕 𐑦𐑑.
He shakes it.
𐑣𐑰 𐑖𐑱𐑒𐑕 𐑦𐑑.
He tries to extract it by scraping it along the ground, and hurts himself
𐑣𐑰 𐑑𐑮𐑲𐑟 𐑑 𐑦𐑒𐑕𐑑𐑮𐑨𐑒𐑑 𐑦𐑑 𐑚𐑲 𐑕𐑒𐑮𐑱𐑐𐑦𐑙 𐑦𐑑 𐑩𐑤𐑪𐑙 𐑞 𐑜𐑮𐑬𐑯𐑛, 𐑯 𐑣𐑻𐑑𐑕 𐑣𐑦𐑥𐑕𐑧𐑤𐑓
worse.
𐑢𐑻𐑕.
He roars piteously.
𐑣𐑰 𐑮𐑹𐑟 PITEOUSLY.
He licks it again.
𐑣𐑰 𐑤𐑦𐑒𐑕 𐑦𐑑 𐑩𐑜𐑧𐑯.
Tears drop from his eyes.
𐑑𐑺𐑟 𐑛𐑮𐑭𐑐 𐑓𐑮𐑩𐑥 𐑣𐑦𐑟 𐑲𐑟.
He limps painfully off the path and lies down under the trees,
𐑣𐑰 𐑤𐑦𐑥𐑐𐑕 𐑐𐑱𐑯𐑓𐑩𐑤𐑰 𐑪𐑓 𐑞 𐑐𐑨𐑔 𐑯 𐑤𐑲𐑟 𐑛𐑬𐑯 𐑩𐑯𐑛𐑻 𐑞 𐑑𐑮𐑰𐑟,
exhausted with pain.
𐑦𐑜𐑟𐑪𐑕𐑑𐑩𐑛 𐑢𐑦𐑞 𐑐𐑱𐑯.
Heaving a long sigh, like wind in a trombone, he goes to sleep.
𐑣𐑰𐑝𐑦𐑙 𐑩 𐑤𐑪𐑙 𐑕𐑲, 𐑤𐑲𐑒 𐑢𐑲𐑯𐑛 𐑦𐑯 𐑩 𐑑𐑮𐑭𐑥𐑚𐑴𐑯, 𐑣𐑰 𐑜𐑴𐑟 𐑑 𐑕𐑤𐑰𐑐.
Androcles and his wife Megaera come along the path.
ANDROCLES 𐑯 𐑣𐑦𐑟 𐑢𐑲𐑓 MEGAERA 𐑒𐑩𐑥 𐑩𐑤𐑪𐑙 𐑞 𐑐𐑨𐑔.
He is a small, thin, ridiculous little man who might be any age from
𐑣𐑰 𐑦𐑟 𐑩 𐑕𐑥𐑪𐑤, 𐑔𐑦𐑯, 𐑮𐑦𐑛𐑦𐑒𐑘𐑩𐑤𐑩𐑕 𐑤𐑦𐑑𐑩𐑤 𐑥𐑨𐑯 𐑣𐑵 𐑥𐑲𐑑 𐑚𐑰 𐑧𐑯𐑰 𐑱𐑡 𐑓𐑮𐑩𐑥
thirty to fifty-five.
𐑔𐑻𐑛𐑰 𐑑 𐑓𐑦𐑓𐑑𐑰-𐑓𐑲𐑝.
He has sandy hair, watery compassionate blue eyes, sensitive nostrils,
𐑣𐑰 𐑣𐑨𐑟 𐑕𐑨𐑯𐑛𐑰 𐑣𐑺, 𐑢𐑪𐑑𐑻𐑰 𐑒𐑩𐑥𐑐𐑨𐑖𐑩𐑯𐑩𐑑 𐑚𐑤𐑵 𐑲𐑟, 𐑕𐑧𐑯𐑕𐑩𐑑𐑦𐑝 𐑯𐑭𐑕𐑑𐑮𐑩𐑤𐑟,
and a very presentable forehead; but his good points go no further;
𐑯 𐑩 𐑝𐑺𐑰 𐑐𐑮𐑩𐑟𐑧𐑯𐑑𐑩𐑚𐑩𐑤 𐑓𐑹𐑣𐑧𐑛; 𐑚𐑩𐑑 𐑣𐑦𐑟 𐑜𐑫𐑛 𐑐𐑶𐑯𐑑𐑕 𐑜𐑴 𐑯𐑴 𐑓𐑻𐑞𐑻;
his arms and legs and back, though wiry of their kind, look
𐑣𐑦𐑟 𐑸𐑥𐑟 𐑯 𐑤𐑧𐑜𐑟 𐑯 𐑚𐑨𐑒, 𐑞𐑴 𐑢𐑽𐑰 𐑝 𐑞𐑺 𐑒𐑲𐑯𐑛, 𐑤𐑫𐑒
shrivelled and starved.
SHRIVELLED 𐑯 𐑕𐑑𐑸𐑝𐑛.
He carries a big bundle, is very poorly clad, and seems tired and hungry.
𐑣𐑰 𐑒𐑨𐑮𐑰𐑟 𐑩 𐑚𐑦𐑜 𐑚𐑩𐑯𐑛𐑩𐑤, 𐑦𐑟 𐑝𐑺𐑰 𐑐𐑫𐑮𐑤𐑰 𐑒𐑤𐑨𐑛, 𐑯 𐑕𐑰𐑥𐑟 𐑑𐑲𐑻𐑛 𐑯 𐑣𐑩𐑙𐑜𐑮𐑰.
His wife is a rather handsome pampered slattern,
𐑣𐑦𐑟 𐑢𐑲𐑓 𐑦𐑟 𐑩 𐑮𐑨𐑞𐑻 𐑣𐑨𐑯𐑕𐑩𐑥 𐑐𐑨𐑥𐑐𐑻𐑛 SLATTERN,
well fed and in the prime of life.
𐑢𐑧𐑤 𐑓𐑧𐑛 𐑯 𐑦𐑯 𐑞 𐑐𐑮𐑲𐑥 𐑝 𐑤𐑲𐑓.
She has nothing to carry, and has a stout stick to help her along.
𐑖𐑰 𐑣𐑨𐑟 𐑯𐑩𐑔𐑦𐑙 𐑑 𐑒𐑨𐑮𐑰, 𐑯 𐑣𐑨𐑟 𐑩 𐑕𐑑𐑬𐑑 𐑕𐑑𐑦𐑒 𐑑 𐑣𐑧𐑤𐑐 𐑣𐑻 𐑩𐑤𐑪𐑙.
