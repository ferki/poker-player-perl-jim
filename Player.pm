package Player;

use strict;
use warnings;

our $VERSION = '0.0.5';

sub new {
    my $class = shift;
    my $self  = {};
    return bless $self, $class;
}

sub bet_request {
    my ( $self, $game_state ) = @_;
    $self->{game_state} = $game_state;
    return &strategos;
}

sub check { }

sub showdown { }

sub version {
    my $self = shift;
    return $self->VERSION;
}

sub strategos {
    my $bet  = 2;
    my @hand = &get_my_hand;
    $bet = 5 if &has_pair;
    return $bet;
}

sub get_my_hand {
    my $self       = shift;
    my $game_state = $self->{game_state};

    foreach my $player ( @{ $game_state->{players} } ) {
        next if $player->{name} ne 'Perl Jim';
        return @{ $player->{hole_cards} };
    }
}

sub has_pair {
    my @hands = shift;
    return $hands[0]->{rank} = $hands[1]->{rank} ? 1 : 0;
}

1;
