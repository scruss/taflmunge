#!/usr/bin/perl -w
# taflmunge.pl - read and process a data.gc.ca TAFL file
# takes two args: a description file and the tafl table itself
#  should probably use supplied 'taflds-new.txt', as original
#  was not-quite computer readable ...
# created by scruss on 02013/07/22
# Licence: WTFPL.

use strict;
use Text::CSV_XS;    # resisting temptation to roll my own parser

my $headings_ref = get_headings( $ARGV[0] );
get_tafl( $ARGV[1], $headings_ref );
exit;

sub get_tafl {
    my $taflfile = shift;
    my $h_ref    = shift;
    my %headings = %$h_ref;
    my @records;

    my $csv = Text::CSV_XS->new(
        {
            sep_char    => "\t",
            quote_space => 0,
            eol         => "\n"
        }
    ) or die "Cannot use CSV: " . Text::CSV->error_diag();

    # reconstitute original field order from 'order' value in headings hash
    my %heads = map { $headings{$_}->{order} => $_ } keys(%headings);
    my @sorted_heads = map { $heads{$_} } sort( { $a <=> $b } keys(%heads) );
    $csv->print( *STDOUT, \@sorted_heads );
    open( TAFL, $taflfile ) or die("$!: Can't open $taflfile\n");
    while (<TAFL>) {
        chomp;
        my %record = ();
        foreach my $key ( keys(%headings) ) {
            $record{$key} = substr(
                $_,
                $headings{$key}->{'start'},
                $headings{$key}->{'length'}
            );

            # some sites have embedded quotes thru bad import hygiene
            $record{$key} =~ tr/"/ /;

            # normalize spacing
            $record{$key} =~ s/\s+/ /g;
            $record{$key} =~ s/^ //;
            $record{$key} =~ s/ $//;

            # convert lat/longs
            if ( $key eq 'LAT' ) {
                if (   ( exists( $record{$key} ) )
                    && ( length( $record{$key} ) > 5 ) )
                {
                    $record{$key} = ddmmss2dd( $record{$key} );
                }
            }
            if ( $key eq 'LONG' ) {
                if (   ( exists( $record{$key} ) )
                    && ( length( $record{$key} ) > 5 ) )
                {
                    # we're west in Canada, so it's negative
                    $record{$key} = 0.0 - ddmmss2dd( $record{$key} );
                }
            }

            # date needs cleaned up
            if ( $key eq 'DATE' ) {
                if (   ( exists( $record{$key} ) )
                    && ( length( $record{$key} ) > 7 ) )
                {
                    $record{$key} = join( '-',
                        substr( $record{$key}, 0, 4 ),
                        substr( $record{$key}, 4, 2 ),
                        substr( $record{$key}, 6, 2 ) );
                }
            }

            # freq: stored in Hz, expected in MHz
            # 000000206204 → 0.206204 (206.204 kHz)
            # 039350000000 → 39350    ( 39.35  GHz)

            if ( $key =~ m/^[TR]X$/ ) {
                if (   ( exists( $record{$key} ) )
                    && ( length( $record{$key} ) > 4 ) )
                {
                    # string convert Hz to MHz
                    my $a = join( '.',
                        substr( $record{$key}, 0, 6 ),
                        substr( $record{$key}, 6, 6 ) );
                    $a =~ s/^0+//;
                    $a += 0.0;
                    $record{$key} = $a;
                }
            }

            if ( $key eq 'RECID' ) {
                if (   ( exists( $record{$key} ) )
                    && ( length( $record{$key} ) > 4 ) )
                {
                    $record{$key} =~ s/^0+//;
                    $record{$key} += 0.0;
                }
            }

            # remove blank cruft
            $record{$key} = undef if ( $record{$key} eq '' );
        }

        # zap TX record if classed as RX only
        $record{'TX'} = undef
          if ( defined( $record{'FLAGRXONLY'} )
            && ( $record{'FLAGRXONLY'} eq '1' ) );

        my @out = map { $record{$_} } @sorted_heads;
        $csv->print( *STDOUT, \@out );
    }
    close(TAFL);

}

sub get_headings {
    my $descfile = shift;
    my $shortref = shift;
    my %headings = ();

    open( DESC, $descfile ) or die("$!: Can't open $descfile\n");
    my $line = 1;
    while (<DESC>) {
        chomp;
        $line++;
        next if ( $line < 8 );    # skip header
        s/\s+/ /g;
        my @fields    = split;
        my %fields_of = ();
        if ( $#fields >= 4 ) {    # a data line
            $fields_of{'type'}   = pop(@fields);
            $fields_of{'length'} = pop(@fields);
            $fields_of{'length'} += 0;    # numeric
            my $junk = pop(@fields);      # don't need 3rd last
            $fields_of{'start'} = pop(@fields);
            $fields_of{'start'}--;        # perl column positions start at 0
            $fields_of{'order'} = $line;  # to reconstruct array in order
            my $name = join( ' ', @fields );

            # junk fields we don't need are named SKIP____
            next if ( $name =~ m/^SKIP/ );
            $headings{$name} = \%fields_of;
        }
    }
    close(DESC);
    return \%headings;
}

sub ddmmss2dd {

    # convert string of format [d]ddmmss to [d]dd.dddd…
    # does bad and weird things if input is negative
    my $l = shift;
    $l =~ s/^0//;    # remove leading zero
    my $s = $l % 100;
    my $m = int( $l / 100 ) % 100;
    my $d = int( $l / 10000 );
    return ( $d + $m / 60 + $s / 3600 );
}
