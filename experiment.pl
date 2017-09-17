#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;
use Crewmember;

my $sub;
say "Hello";
my $object = Crewmember->new( 'Ivanov Ivan Ivanovich', 'leutenant', 'gunner', '10 years', 'T-34' );
say "Bye";
say $object->get_set_fullname( );