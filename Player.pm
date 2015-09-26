package Player;

use strict;
use warnings;

our $VERSION = '0.0.13';

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
    $self->{phase}      = $self->get_phase;
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
    if ( $self->has_pair ) {
        $bet = $self->raise_amount;
        $bet = $self->allin_amount if ( $self->has_ace or $self->has_king );
    }
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

sub raise_amount {
    my $self = shift;
    return 100;
}

sub check_amount {
    my $self = shift;
    return $self->{game_state}->{current_buyin};
}

sub fold_amount {
    my $self = shift;
    return 0;
}

sub allin_amount {
    my $self = shift;
    return $self->{stack};
}

sub get_phase {
    my $self            = shift;
    my $community_cards = $self->{game_state}->{community_cards};
    my $num_cards       = scalar @$community_cards;

    if ( $num_cards == 0 ) {
        return 'preflop';
    }
    elsif ( $num_cards = 3 ) {
        return 'flop';
    }
    elsif ( $num_cards = 4 ) {
        return 'turn';
    }
    elsif ( $num_cards = 5 ) {
        return 'river';
    }
}

1;
