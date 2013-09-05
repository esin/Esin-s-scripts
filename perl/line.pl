#!/usr/bin/perl -w
# line.pl
# Cut file for string from BEGIN to END
#
# Using:
# line.pl FILENAME BEGIN END
#

sub how_to {
	$0 =~ s{.*/}{};
	print "$0 FILENAME BEGIN END\n";
	exit;
}

how_to() if ( $#ARGV < 2);
die "$!" if ( ! -e $ARGV[0] );

my $begin = $ARGV[2];
my $end = $ARGV[2] - $ARGV[1] + 1;

exit if ($end > $begin);

print `cat $ARGV[0] | head -n $begin | tail -n $end`;

exit;
