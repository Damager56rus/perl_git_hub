#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;
use Military_materiel;

my $sub;
say "Hello";
my $object = Military_materiel->new( 'plane', 'T-34', '100', '250', '300' );
say "Bye";
say $object->get_hit( '100' );
say $object->{ strength };