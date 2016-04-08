use strict;
use warnings;

sub convert_svg {
    my ($in_svg, $out_svg, $conversion) = @_;
    open my $in_file, "<", $in_svg or die "Cannot open $in_svg: $!";
    my $in_data = do { local $/; <$in_file> };
    close $in_file;
    
    my $out_data = $conversion->($in_data);
    open my $out_file, ">", $out_svg or die "Cannot open $out_svg: $!";
    print $out_file $out_data;
    close $out_file;
}


my %color_for = (
    '' => '#000000',
    '-selected' => '#FFFFFF',
    '-insensitive' => '#999999'
);

my $TEMP_SVG = "temp.svg";

foreach my $shape ('checked', 'mixed') {
    foreach my $occasion (keys %color_for) {
        my $in_svg = "menuitem-$shape.svg";
        my $out_png = "menuitem-checkbox-$shape$occasion.png";
        my $out_color = $color_for{$occasion};
        convert_svg($in_svg, $TEMP_SVG, sub {
            my ($data) = @_;
            $data =~ s/stroke:#000000;/stroke:$out_color;/;
            return $data;
        });
        my $size = 16;
        system('inkscape', "--export-png=$out_png", "--export-area-page", "--export-width=$size", "--export-height=$size", $TEMP_SVG);
    }
}
unlink($TEMP_SVG);
