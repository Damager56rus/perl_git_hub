# Практика по ООП №2
package Military_materiel;

use Modern::Perl;
use Weapon_type;

our @ISA = ( 'Weapon_type' ); # для наследования методов take_aim и fire

sub new {
    my ( $class, $type, $model_name, $speed, $armor, $strength, $weapon_type, $ammunition_amount ) = @_;
    my $self = { };
    
    if ( $type =~ /^tank$|^plane$/i ) {
         $self->{ type } = $type; # тип техники: танк или самолет
    }
    else { die "Invalid value for type!"; }

    if ( $model_name =~ /\w+/i ) {
         $self->{ model_name } = $model_name; # название модели
    }
    else { die "Invalid value for model_name!"; }

    if ( $speed =~ /^\d+$/ ) {
         $self->{ speed } = $speed; # скорость
    }
    else { die "Invalid value for speed!"; }

    if ( $armor =~ /^\d+$/ ) {
         $self->{ armor } = $armor; # толщина брони
    }
    else { die "Invalid value for armor!"; }

    if ( $strength =~ /^\d+$/ ) {
         $self->{ strength } = $strength; # прочность
    }
    else { die "Invalid value for strength!"; }

    if ( $type =~ /tank/i && $weapon_type =~ /^cannon$|^machine_gun$/ ) { # если тип оружия подходит для техники
         $self->{ weapon } = Weapon_type->new( $weapon_type, $ammunition_amount ); # установить оружие на танк
    }
    elsif ( $type =~ /plane/i && $weapon_type =~ /^rocket$|^machine_gun$/ ) {
            $self->{ weapon } = Weapon_type->new( $weapon_type, $ammunition_amount ); # установить оружие на самолет
    }
    else { # если тип оружия не подходит для техники
            die "Invalid value for weapon_type!";
    }

    bless $self, $class;
    
    if ( $type =~ /tank/i ) {
         say $self->{ type }, " took the position."; # танк занял позицию
    }
    elsif ( $type =~ /plane/i ) {
            say $self->{ type }, " took off."; # самолет взлетел
    }

    return $self;
}

sub get_set_speed {
    my ( $self, $speed ) = @_;

    if ( defined $speed ) { 
         if ( $speed =~ /^\d+$/ ) {
              return say "New speed value is: ", $self->{ speed } = $speed; # новое значение скорости
         }
         else { die "Invalid new value for speed!"; }
    }
    else { return say "Current speed value is: ", $self->{ speed }; } # текущее значение для скорости
}

sub get_set_strength {
    my ( $self, $strength ) = @_;

    if ( defined $strength ) { 
         if ( $strength =~ /^\d+$/ ) {
              return say "New strength value is: ", $self->{ strength } = $strength;
         }
         else { die "Invalid new value for strength!"; }
    }
    else { return say "Current strength value is: ", $self->{ strength }; }
}

sub moving {
    my $self = shift;

    if ( $self->{ type } =~ /tank/i ) {
         return ride_the_ground( $self );
    }
    elsif ( $self->{ type } =~ /plane/i ) {
         return flying( $self );
    }
}

sub ride_the_ground {
    my $self = shift;

    return say $self->{ type }, " rides the ground."; # ехать по земле
}

sub flying {
    my $self = shift;

    unless ( $self->{ type } =~ /plane/i  ) {
             return say DESTROY( $self );
    }

    return say $self->{ type }, " is flying."; # лететь
}

sub get_hit {
    my ( $self, $damage ) = @_;
    $self->{ strength } -= $damage;      
    my $destroy_probability = int( rand( 10 ) ); # вероятность уничтожения 10% при попадании

    if ( $self->{ strength } <= 0 || $destroy_probability == 5) { 
         return say DESTROY( $self ); 
    }

    return say "Strength value is: ", $self->{ strength }; # толщина брони после попадания
}

sub DESTROY {
    my $self = shift;

    return $self->{ type }, " destroyed!";
}

1;