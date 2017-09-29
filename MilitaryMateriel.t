#!/usr/bin/perl
# Тестирование модуля MilitaryMateriel 
# с использованием Test::More

use Test::More tests => 32;
use Modern::Perl;
use MilitaryMateriel;

use_ok( 'WeaponType' );

# Доступность всех методов
my @methods = ( 
	 'new', 
	 'get_set_speed',
	 'get_set_strength',
	 'moving', 
     'ride_the_ground',
     'flying',
     'get_hit',
     'DESTROY',
);

foreach my $methods ( @methods ) {
        can_ok( 'MilitaryMateriel', $methods );
}

# Работа конструктора при корректных значениях аргументов
my $plane_with_rocket = MilitaryMateriel->
   new( 'plane', 'SU-27', '200', '250', '300', 'rocket', '5' );

isa_ok( $plane_with_rocket, 'MilitaryMateriel', 'Test customer' );

# Возврат сообщений о некорректных значениях аргументов
is( MilitaryMateriel->new( 'car' ), 'Invalid value for type!', 
	'Should return: Invalid value for type!' );

is( MilitaryMateriel->new( 'plane', '%' ), 'Invalid value for model_name!', 
	'Should return: Invalid value for model_name!' );

is( MilitaryMateriel->new( 'plane', 'SU-27', '200x' ), 'Invalid value for speed!', 
	'Should return: Invalid value for speed!' );

is( MilitaryMateriel->new( 'plane', 'SU-27', '200', '250x' ), 'Invalid value for armor!', 
	'Should return: Invalid value for armor!' );

is( MilitaryMateriel->new( 'plane', 'SU-27', '200', '250', '300x' ), 'Invalid value for strength!', 
	'Should return: Invalid value for strength!' );

# Установка оружия
my $tank_with_cannon = MilitaryMateriel->
   new( 'tank', 'T-34', '100', '150', '200', 'cannon', '20' );

isa_ok( $tank_with_cannon->{weapon}, 'WeaponType' );

my $tank_with_machine_gun = MilitaryMateriel->
   new( 'tank', 'T-34', '100', '150', '200', 'machine_gun', '200' );

isa_ok( $tank_with_machine_gun->{weapon}, 'WeaponType' );

isa_ok( $plane_with_rocket->{weapon}, 'WeaponType' );

my $plane_with_machine_gun = MilitaryMateriel->
   new( 'plane', 'SU-27', '200', '250', '300', 'machine_gun', '200' );

isa_ok( $plane_with_machine_gun->{weapon}, 'WeaponType' );

is( MilitaryMateriel->new( 'tank', 'T-34', '100', '150', '200', 'rocket', '5' ), 
	'Invalid value for weapon_type!', 'Should return: Invalid value for weapon_type!' );

is( MilitaryMateriel->new( 'plane', 'SU-27', '200', '250', '300', 'cannon', '20' ), 
	'Invalid value for weapon_type!', 'Should return: Invalid value for weapon_type!' );

# Пока непонятно как перехватывать say, чтобы
# проверить логику печати "танк занял позицию" и "самолет взлетел"

# Методы get_set
is( $plane_with_rocket->get_set_speed, '200', 'Should return: 200' );
is( $plane_with_rocket->get_set_speed( '250' ), '250', 'Should return: 250' );
is( $plane_with_rocket->get_set_speed( '250x' ), 'Invalid new value for speed!', 
	'Should return: Invalid new value for speed!' );

is( $plane_with_rocket->get_set_strength, '300', 'Should return: 300' );
is( $plane_with_rocket->get_set_strength( '350' ), '350', 'Should return: 350' );
is( $plane_with_rocket->get_set_strength( '350x' ), 'Invalid new value for strength!', 
	'Should return: Invalid new value for strength!' );

# Методы moving и flying
is( $tank_with_cannon->moving, ' rides the ground.', 'Should return: rides the ground' );
is( $plane_with_rocket->moving, ' is flying.', 'Should return: is flying' );
is( $tank_with_cannon->flying, ' destroyed!', 'Should return: destroyed!' );

# Метод get_hit
$tank_with_cannon->get_hit( '10' );
ok( $tank_with_cannon->{strength} == 190, 'strength should be minus 10' );

$tank_with_cannon->get_set_strength( '0' );
is( $tank_with_cannon->get_hit( '10' ), ' destroyed!', 'Should return: destroyed!' );