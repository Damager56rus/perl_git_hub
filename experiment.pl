#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;
#use Military_materiel;
use Cannon;

#my $object = Military_materiel->new( 'tank', 'T-34', '100', '250', '300', 'cannon' );
#say $object->get_hit( '100' );
#say $object->{ strength };
#say $object->shoot_cannon( );

my $object = Cannon->new( 'cannon', '10' );
say $object->fire();
say $object->{ ammunition_amount };