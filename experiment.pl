#!/usr/bin/perl

use Modern::Perl;
use Data::Dumper;
use Crewmember;

my $sub;
say "Hello";
my $object = Crewmember->new( 'Gubachev Dmitriy Valerievich', 'leutenant', 'gunner', '10 years', 'Т-34' );
say "Bye";
say $object->get_set_speciality( 'commander' );