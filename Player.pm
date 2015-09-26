package Player;

use strict;
use warnings;

our $VERSION = '0.0.7 - The Bond Edition';

sub new {
    my $class = shift;
    my $self  = {};
    return bless $self, $class;
}

sub bet_request {
    my ( $self, $game_state ) = @_;
    $self->{game_state} = $game_state;
    $self->{hand}       = $self->get_my_hand;
    return &strategos;
}

sub check { }

sub showdown { }

sub version {
    my $self = shift;
    return $self->VERSION;
}

sub strategos {
    my $self = shift;
    my $bet  = 0;
    $bet = 100 if $self->has_pair;
    return $bet;
}

sub get_my_hand {
    my $self       = shift;
    my $game_state = $self->{game_state};

    foreach my $player ( @{ $game_state->{players} } ) {
        next if $player->{name} ne 'Perl Jim';
        return [ @{ $player->{hole_cards} } ];
    }
}

sub has_pair {
    my $self = shift;
    return $self->{hand}[0]->{rank} = $self->{hand}[1]->{rank} ? 1 : 0;
}

1;
