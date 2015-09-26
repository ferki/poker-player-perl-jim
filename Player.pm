package Player;

use strict;
use warnings;

our $VERSION = '0.0.0';

sub new {
    my ( $class, $args ) = @_;
    return bless \$args, $class;
}

sub bet_request {
    my ( $self, $game_state ) = @_;
    return 2;
}

sub check { }

sub showdown { }

sub version {
    my $self = shift;
    return $self->VERSION;
}

sub get_my_hand {
    my $game_state = shift;
    foreach my $player ( @{ $game_state->{players} } ) {
        next if $player->{name} ne 'Perl Jim';
        return { $player->{hole_cards} };
    }
}

1;
