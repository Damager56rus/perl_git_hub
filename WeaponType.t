#!/usr/bin/perl
# Тестирование модуля WeaponType 
# с использованием Test::More

use Test::More tests => 14;
use Modern::Perl;
use WeaponType;

# Доступность всех методов
my @methods = ( 
	 'new', 
	 'take_aim',
	 'fire', 
	 'recharge',
);

foreach my $methods ( @methods ) {
        can_ok( 'WeaponType', $methods );
}

# Работа конструктора при корректных значениях аргументов
my $machine_gun = WeaponType->new( 'machine_gun', '200' );
isa_ok( $machine_gun, 'WeaponType', 'Test customer' );

# Возврат сообщений о некорректных значениях аргументов
is( WeaponType->new( 'pistol' ), 'Invalid value for type!', 
	'Should return: Invalid value for type!' );

is( WeaponType->new( 'machine_gun', '200x' ), 'Invalid value for ammunition_amount!', 
	'Should return: Invalid value for ammunition_amount!' );

# Установка размера магазина
is( $machine_gun->{magazin}, '10', 'Should return: 10' );

my $cannon = WeaponType->new( 'cannon', '20' );
is( $cannon->{magazin}, '0', 'Should return: 0' );

my $rocket = WeaponType->new( 'rocket', '5' );
is( $rocket->{magazin}, '0', 'Should return: 0' );

# Метод fire
is( $rocket->fire, ' fired!', 'Should return: fired!' );

$rocket->{ammunition_amount} = 0;
is( $rocket->fire, 'Not enough ammunition_amount!', 
	'Should return: Not enough ammunition_amount!' );

# Метод recharge
$machine_gun->{magazin} = 0;
is( $machine_gun->recharge, ' is reloaded!', 'Should return: is reloaded!' );

is( $cannon->recharge, ' is reloaded!', 'Should return: is reloaded!' );