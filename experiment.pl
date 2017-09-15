#!/usr/bin/perl

use Modern::Perl;
use Moose;
use location;

my $game_area = location->new( 'number' => '1', 'size_x' => '500', 'size_y' => '500' )->
my $object = location->create_object( 'name' => 'Earth', 'coordinate_x' => '10', 'coordinate_y' => '20' );

say $game_area;