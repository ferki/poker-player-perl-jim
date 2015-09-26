package Player;

use strict;
use warnings;

our $VERSION = '0.0.4';

sub new {
    my ( $class, $args ) = @_;
    return bless \$args, $class;
}

sub bet_request {
    my ( $self, $game_state ) = @_;
    return &strategos($game_state);
}

sub check { }

sub showdown { }

sub version {
    my $self = shift;
    return $self->VERSION;
}

sub strategos {
    my $game_state = shift;
    my $bet        = 2;
    my @hand       = &get_my_hand($game_state);
    $bet = 5 if &has_pair;
    return $bet;
}

sub get_my_hand {
    my $game_state = shift;
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
