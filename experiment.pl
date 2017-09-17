#!/usr/bin/perl

use Modern::Perl;
use Location;

my $game_area = Location->new_game_area( '1', '500', '500' );
say $game_area->get_number();