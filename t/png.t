use Test::More tests => 46;

use warnings;
use strict;

use PDF::API2;

my $pdf = PDF::API2->new();
$pdf->{forcecompress} = 0;

my $png = $pdf->image_png('t/resources/1x1.png');
isa_ok($png, 'PDF::API2::Resource::XObject::Image::PNG',
       q{$pdf->image_png()});

my $gfx = $pdf->page->gfx();
$gfx->image($png, 72, 144, 216, 288);
like($pdf->stringify(), qr/q 216 0 0 288 72 144 cm \S+ Do Q/,
     q{Add PNG to PDF});


# basic formats - not supported files excluded
my @basic_png = (
      basn0g01 => 'black & white'
    , basn0g02 => '2 bit (4 level) grayscale'
    , basn0g04 => '4 bit (16 level) grayscale'
    , basn0g08 => '8 bit (256 level) grayscale'
    #, basn0g16 => '16 bit (64k level) grayscale'
    , basn2c08 => '3x8 bits rgb color'
    #, basn2c16 => '3x16 bits rgb color'
    , basn3p01 => '1 bit (2 color) paletted'
    , basn3p02 => '2 bit (4 color) paletted'
    , basn3p04 => '4 bit (16 color) paletted'
    , basn3p08 => '8 bit (256 color) paletted'
    , basn4a08 => '8 bit grayscale + 8 bit alpha-channel'
    #, basn4a16 => '16 bit grayscale + 16 bit alpha-channel'
    , basn6a08 => '3x8 bits rgb color + 8 bit alpha-channel'
    #, basn6a16 => '3x16 bits rgb color + 16 bit alpha-channel'
);

# same as above but interlaced - but not supported yet
my @interlaced_png = (
   #   basi0g01 => 'interlacing black & white'
   # , basi0g02 => 'interlacing 2 bit (4 level) grayscale'
   # , basi0g04 => 'interlacing 4 bit (16 level) grayscale'
   # , basi0g08 => 'interlacing 8 bit (256 level) grayscale'
   # , basi0g16 => 'interlacing 16 bit (64k level) grayscale'
   # , basi2c08 => 'interlacing 3x8 bits rgb color'
   # , basi2c16 => 'interlacing 3x16 bits rgb color'
   # , basi3p01 => 'interlacing 1 bit (2 color) paletted'
   # , basi3p02 => 'interlacing 2 bit (4 color) paletted'
   # , basi3p04 => 'interlacing 4 bit (16 color) paletted'
   # , basi3p08 => 'interlacing 8 bit (256 color) paletted'
   # , basi4a08 => 'interlacing 8 bit grayscale + 8 bit alpha-channel'
   # , basi4a16 => 'interlacing 16 bit grayscale + 16 bit alpha-channel'
   # . basi6a08 => 'interlacing 3x8 bits rgb color + 8 bit alpha-channel'
   # , basi6a16 => 'interlacing 3x16 bits rgb color + 16 bit alpha-channel'
);


foreach my $check (\@basic_png,\@interlaced_png) {
    while(my ($name,$desc) = splice(@$check,0,2)) {
        my $pdf = PDF::API2->new();
        $pdf->{forcecompress} = 0;

        my $imagefile = "t/resources/pngsuite/${name}.png";
        ok(-r $imagefile,"Test png $imagefile is readable");

        eval {
            my $png = $pdf->image_png($imagefile);
            isa_ok($png,
            'PDF::API2::Resource::XObject::Image::PNG',q{$pdf->image_png()});

            my $gfx = $pdf->page->gfx();
            $gfx->image($png, 72, 144, 216, 288);
            like($pdf->stringify(), qr/q 216 0 0 288 72 144 cm \S+ Do Q/,
                qq{Add $desc PNG to PDF});

        };
        if($@) {
            ok(0,"Died with message: $@");
        }
        else {
            ok(1,'image processed without fatal problem');
        }
    }
}
