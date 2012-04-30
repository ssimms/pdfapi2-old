#!/usr/bin/perl 
#===============================================================================
#
#         FILE: pdfinterleave.pl
#
#        USAGE: ./pdfinterleave.pl oddpages.pdf evenpages.pdf
#
#  DESCRIPTION: Interleaves the pages of two pdf files.
#
#      OPTIONS: -r If you need to reverse the evenpages file.
#               -l If you want to discard the last page of evenpages file.
#
# REQUIREMENTS: PDF::API2
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: WELTON RODRIGO TORRES NASCIMENTO (rodrigo@familianascimento.org)
#      VERSION: 1.0
#      CREATED: 27-04-2012 14:22:51
#===============================================================================

use strict;
use warnings;

use PDF::API2;
use Getopt::Long;
Getopt::Long::Configure ("bundling");

my $revert;
my $discardlast;
my $help;

sub usage {
    print "Usage: $0 oddpages.pdf evenpages.pdf > fulldoc.pdf\n\n"
      . "\t-r If you need to reverse the evenpages file.\n"
      . "\t-l If you want to discard the last page of evenpages file.\n";
}

GetOptions(
    "r"   => \$revert,
    "l"   => \$discardlast,
    "h|help"   => \$help, 
);

usage() and exit 0 if $help or @ARGV < 2;

my $new  = PDF::API2->new();
my $odd  = PDF::API2->open(shift);
my $even = PDF::API2->open(shift);

my $opages =  $odd->pages();
my $epages = $even->pages();

my $max    = $opages > $epages? $opages : $epages;

PAGE:
for (my $i = 1; $i <= $max; $i++){
	my $page = $i;

	# One from odd...
	$new->importpage($odd,  $page) unless $i > $opages;

	# reverse even?
	$page = $epages + 1 - $i if defined $revert; 
	
	# discard last?
	next PAGE if $discardlast and $i == $epages;

	# ... one from even
	$new->importpage($even, $page ) unless $i > $epages;
}

$new->saveas("-");
