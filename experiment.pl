#!/usr/bin/perl

use Modern::Perl;
#use Game_area;
use Location_object;
#use Mojo::Log;

#my $area = Game_area->new( '1', '500', '500' );

#say $area->spawn_enimes();

my $planet = Location_object->new( 'Earth', '10', '10','1' );
say $planet->move_by_object( '4' );

#my $log = Mojo::Log->new( path => 'log.log' );