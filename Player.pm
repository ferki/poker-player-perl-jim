package Player;

use strict;
use warnings;
use POSIX;

our $VERSION = '0.0.27';

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

    if ( $self->{phase} eq 'preflop' ) {

        #preflop
        $bet = $self->check_amount if not $self->raised_pot;    # default

        if ( $self->has_pair ) {                                #pairs
            $bet = $self->raise_amount if not $self->raised_pot;    # low pairs
            $bet = $self->raise_amount
              if ( $self->has_ace or $self->has_king );             # AA,KK
        }
        if ( $self->has_ace and $self->has_king ) {                 #AK
            $bet = $self->raise_amount if not $self->raised_pot;
        }
    }
    else {
        #postflop
        $bet = $self->check_amount;                                 # default

        if ( $self->has_pair ) {
            $bet = $self->raise_amount if not $self->raised_pot;    # low pairs
            $bet = $self->raise_amount
              if ( $self->has_ace or $self->has_king );             # AA,KK
        }
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
    return $self->rank_diff == 0 ? 1 : 0;
}

sub has_connector {
    my $self = shift;
    return $self->rank_diff == 1 ? 1 : 0;
}

sub has_suited {
    my $self = shift;
    return $self->{hand}[0]->{suit} eq $self->{hand}[1]->{suit} ? 1 : 0;
}

sub has_rank {
    my $self = shift;
    my $rank = shift;
    return (
             $self->{hand}[0]->{rank} eq $rank
          or $self->{hand}[1]->{rank} eq $rank
    ) ? 1 : 0;
}

sub has_ace {
    my $self = shift;
    return $self->has_rank('A') ? 1 : 0;
}

sub has_king {
    my $self = shift;
    return $self->has_rank('K') ? 1 : 0;
}

sub raise_amount {
    my $self = shift;
    my $bet  = 0;
    if ( $self->{phase} eq 'preflop' ) {
        if ( $self->{game_state}->{pot} >
            $self->{game_state}->{small_blind} * 3 )
        {
            $bet = ceil( $self->{game_state}->{pot} * 0.75 );
        }
        else {
            $bet = $self->{game_state}->{small_blind} * 2 * 4;
        }
    }
    else {
        $bet = ceil( $self->{game_state}->{pot} * 0.75 );
    }
}

sub check_amount {
    my $self = shift;
    return $self->{game_state}->{current_buy_in};
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

sub rank_diff {
    my $self  = shift;
    my $rank1 = $self->{hand}[0]->{rank};
    my $rank2 = $self->{hand}[1]->{rank};
    my %map   = ( T => 10, J => '11', Q => '12', K => '13', A => '14' );

    $rank1 = $map{$rank1};
    $rank2 = $map{$rank2};

    my $diff = abs( $rank1 - $rank2 );
    $diff = 1 if $diff == 12;

    return $diff;
}

sub raised_pot {
    my $self       = shift;
    my $raised_pot = 0;
    if ( $self->{phase} eq 'preflop' ) {
        if ( $self->{game_state}->{current_buy_in} >
            $self->{game_state}->{small_blind} * 3 )
        {
            $raised_pot = 1;
        }
    }
    elsif ( $self->{game_state}->{current_buy_in} > 0 ) {
        $raised_pot = 1;
    }

    return $raised_pot;
}

1;
