package Player;

use strict;
use warnings;

our $VERSION = '0.0.9';

sub new {
    my $class = shift;
    my $self  = {};
    return bless $self, $class;
}

sub bet_request {
    my ( $self, $game_state ) = @_;
    $self->{game_state} = $game_state;
    $self->{hand}       = $self->get_my_hand;
    $self->{stack}      = $self->get_my_stack;
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
        return $player->{hole_cards};
    }
}

sub get_my_stack {
    my $self       = shift;
    my $game_state = $self->{game_state};

    foreach my $player ( @{ $game_state->{players} } ) {
        next if $player->{name} ne 'Perl Jim';
        return $player->{stack};
    }
}

sub has_pair {
    my $self = shift;
    return $self->{hand}[0]->{rank} eq $self->{hand}[1]->{rank} ? 1 : 0;
}

sub has_suited {
    my $self = shift;
    return $self->{hand}[0]->{suit} eq $self->{hand}[1]->{suit} ? 1 : 0;
}

sub has_ace {
    my $self = shift;
    return (
             $self->{hand}[0]->{rank} eq 'A'
          or $self->{hand}[1]->{rank} eq 'A'
    ) ? 1 : 0;
}

sub has_king {
    my $self = shift;
    return (
             $self->{hand}[0]->{rank} eq 'K'
          or $self->{hand}[1]->{rank} eq 'K'
    ) ? 1 : 0;
}

1;
