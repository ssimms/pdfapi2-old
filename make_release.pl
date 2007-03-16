#!perl
#=======================================================================
#    ____  ____  _____              _    ____ ___   ____
#   |  _ \|  _ \|  ___|  _   _     / \  |  _ \_ _| |___ \
#   | |_) | | | | |_    (_) (_)   / _ \ | |_) | |    __) |
#   |  __/| |_| |  _|    _   _   / ___ \|  __/| |   / __/
#   |_|   |____/|_|     (_) (_) /_/   \_\_|  |___| |_____|
#
#   A Perl Module Chain to faciliate the Creation and Modification
#   of High-Quality "Portable Document Format (PDF)" Files.
#
#   Copyright 1999-2005 Alfred Reibenschuh <areibens@cpan.org>.
#
#=======================================================================
#
#   This library is free software; you can redistribute it and/or
#   modify it under the terms of the GNU Lesser General Public
#   License as published by the Free Software Foundation; either
#   version 2 of the License, or (at your option) any later version.
#
#   This library is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public
#   License along with this library; if not, write to the
#   Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#   Boston, MA 02111-1307, USA.
#
#   $Id$
#
#=======================================================================

require 5.008;

use Getopt::Long;
use POSIX;

my $versionfile = "lib/PDF/API2/Version.pm";

require "$versionfile";

sub write_version ($) 
{
    my $hex=shift @_;
    my $tim=POSIX::strftime('%Y-%m-%d %H:%M:%S',localtime());
    my $dat=POSIX::strftime('%Y-%m-%d',localtime());
    my $name='PDF::API2';
    # hexversion = VVRRRLLL
    my $rev=($hex>>12) & 0xfff;
    my $ver=($hex>>24) & 0xff;
    my $bld=$hex & 0xfff;
    
    my $triple=sprintf("%u.%02u.%03u",$ver,$rev,$bld);
    my $triple_short=sprintf("%u.%02u",$ver,$rev);
	$triple=$triple_short if($bld==0);
	
    my %hash=(
        'vHex'     => sprintf('0x%08X',$hex),
        'vShort'   => "$triple_short",
        'vLong'    => "$triple",
        'vPerl'    => "$triple",
        'vFredo'   => "$name $triple",
        'vWeb'     => "$name/$triple",
    );
    my $fh;
    open($fh,">$versionfile");
    print $fh <<'EOT';
#=======================================================================
#         _   _    :    ____  ____  _____      _    ____ ___   ____
#     _  |_|_|_|   :   |  _ \|  _ \|  ___|    / \  |  _ \_ _| |___ \
#    |_| _|_||_|   :   | |_) | | | | |_      / _ \ | |_) | |    __) |
#    _  |_||_|_|   :   |  __/| |_| |  _|    / ___ \|  __/| |   / __/
#   |_|  |_|_|_|   :   |_|   |____/|_|     /_/   \_\_|  |___| |_____|
#                  : 
#=======================================================================
package PDF::API2::Version;
BEGIN {
    use vars qw( $VERSION %CVersion );
EOT
    print $fh "    \$VERSION = '$hash{vPerl}';\n";
    print $fh "    \%CVersion = (\n";
    foreach my $k (sort keys %hash) {
    print $fh "        '$k' => '$hash{$k}',\n";
    $PDF::API2::Version::CVersion{$k}=$hash{$k};
    }
    print $fh "    );\n";
    print $fh <<'EOT';
}
1;
EOT
    print $fh "\n__END__\n# autogenerated file -- do not edit.\n\n=pod\n\n=head1 NAME\n\nPDF::API2::Version\n\n=head1 VERSION\n\n";
    foreach my $k (sort keys %hash) {
        printf $fh " %7s: $hash{$k} \n",$k;
    }
    print $fh "\n=cut\n\n";
    close($fh);
    return "$ptriple";
}

my $overide=undef;
my $version=undef;
my $build=undef;
my $release=undef;
my $remake=undef;
my $usage=undef;

GetOptions(
    "override=s" => \$overide,
    "version|v" => \$version,
    "build|q" => \$build,
    "release|r" => \$release,
    "remake|m" => \$remake,
    "help|usage|h" => \$usage,
);

if($usage) 
{
    print <<EOT;
help for Release.PL

    --override .version.    specify version
    --version/-v            increment version part
    --release/-r            increment release part
    --build/-q              increment build part
    --remake/-m             remake version file
    --help/--usage/-h       print this
    
EOT
    exit(0);
}

my $thisVersion=$PDF::API2::Version::CVersion{vPerl};

if($overide) 
{
    $thisVersion=write_version(hex($overide));
} 
elsif($build) 
{
    $thisVersion=write_version(hex($PDF::API2::Version::CVersion{vHex})+1);
} 
elsif($release) 
{
    $thisVersion=write_version((hex($PDF::API2::Version::CVersion{vHex}) & 0xfffff000)+(1<<12));
} 
elsif($version) 
{
    $thisVersion=write_version((hex($PDF::API2::Version::CVersion{vHex}) & 0xff000000)+(1<<24));
} 
elsif($remake) 
{
    $thisVersion=write_version(hex($PDF::API2::Version::CVersion{vHex}));
}

$ENV{HOME}='/';

system qq|/perl/bin/perl.exe Makefile.PL|;
system qq|nmake dist|;
__END__
system qq|nmake install|;

