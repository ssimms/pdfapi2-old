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
#=======================================================================
#
#   THIS IS A REUSED PERL MODULE, FOR PROPER LICENCING TERMS SEE BELOW:
#
#
#   Copyright Martin Hosken <Martin_Hosken@sil.org>
#
#   No warranty or expression of effectiveness, least of all regarding
#   anyone's safety, is implied in this software or documentation.
#
#   This specific module is licensed under the Perl Artistic License.
#
#
#   $Id$
#
#=======================================================================
package PDF::API2::Basic::TTF::Vmtx;

=head1 NAME

PDF::API2::Basic::TTF::Vmtx - Vertical Metrics

=head1 DESCRIPTION

Contains the advance height and top side bearing for each glyph. Given the
compressability of the data onto disk, this table uses information from
other tables, and thus must do part of its output during the output of
other tables

=head1 INSTANCE VARIABLES

The vertical metrics are kept in two arrays by glyph id. The variable names
do not start with a space

=over 4

=item advance

An array containing the advance height for each glyph

=item top

An array containing the top side bearing for each glyph

=back

=head1 METHODS

=cut

use strict;
use vars qw(@ISA);
require PDF::API2::Basic::TTF::Hmtx;

@ISA = qw(PDF::API2::Basic::TTF::Hmtx);


=head2 $t->read

Reads the vertical metrics from the TTF file into memory

=cut

sub read
{
    my ($self) = @_;
    my ($numh, $numg);

    $numh = $self->{' PARENT'}{'vhea'}->read->{'numberOfVMetrics'};
    $numg = $self->{' PARENT'}{'maxp'}->read->{'numGlyphs'};
    $self->_read($numg, $numh, "advance", "top");
}


=head2 $t->out($fh)

Writes the metrics to a TTF file. Assumes that the C<vhea> has updated the
numVMetrics from here

=cut

sub out
{
    my ($self, $fh) = @_;
    my ($numg) = $self->{' PARENT'}{'maxp'}{'numGlyphs'};
    my ($numh) = $self->{' PARENT'}{'vhea'}{'numberOfVMetrics'};
    $self->_out($fh, $numg, $numh, "advance", "top");
}

1;

=head1 BUGS

None known

=head1 AUTHOR

Martin Hosken Martin_Hosken@sil.org. See L<PDF::API2::Basic::TTF::Font> for copyright and
licensing.

=cut

