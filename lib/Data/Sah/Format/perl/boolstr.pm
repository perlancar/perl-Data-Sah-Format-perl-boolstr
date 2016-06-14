package Data::Sah::Format::perl::boolstr;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Data::Dmp;

our $styles = {
    yes_no     => ['yes', 'no'],
    Y_N        => ['Y', 'N'],
    true_false => ['true', 'false'],
    T_F        => ['T', 'F'],
    '1_0'      => ['1', '0'],
    on_off     => ['on', 'off'],
};

sub format {
    my %args = @_;

    my $dt    = $args{data_term};
    my $fargs = $args{args} // {};

    my ($true_str, $false_str);
    if (defined $fargs->{true_str}) {
        die "BUG: both true_str and false_str must be defined"
            unless defined $fargs->{false_str};
        $true_str  = $fargs->{true_str};
        $false_str = $fargs->{false_str};
    } elsif (defined $fargs->{false_str}) {
        die "BUG: both true_str and false_str must be defined";
    } else {
        my $style = $fargs->{style} // 'yes_no';
        $styles->{$style} or die "BUG: Unknown style '$style'";
        $true_str  = $styles->{$style}[0];
        $false_str = $styles->{$style}[1];
    }

    my $res = {};

    $res->{expr} = join(
        "",
        "!defined($dt) ? $dt : $dt ? ".dmp($true_str)." : ".dmp($false_str),
    );

    $res;
}

1;
# ABSTRACT: Format boolean as yes/no, etc

=for Pod::Coverage ^(format)$

=head1 DESCRIPTION

By default will format all values that are regarded as true by Perl with "yes",
and all false values as "no". Undef will be left undef. The true string and
false string can be set using the formatter arguments C<true_str> and
C<false_str>, or you can choose from a set of predefined styles.


=head1 FORMATTER ARGUMENTS

=head2 true_str => str

=head2 false_str => str

=head2 style => str (default: yes_no)

Can be: yes_no, Y_N, true_false, T_F, 1_0, on_off.
