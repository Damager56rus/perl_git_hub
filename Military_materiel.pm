# Практика по ООП №2
package Military_materiel;

use Modern::Perl;

sub new {
    my ( $class, $type, $model_name, $speed, $armor, $strength, $weapon ) = @_;
    my $self = { };
    
    if ( $type =~ /^tank$|^plane$/i ) {
         $self->{ type } = $type; # тип техники: танк или самолет
    }
    else { die "Invalid value for: type!"; }

    if ( $model_name =~ /\w+/i ) {
         $self->{ model_name } = $model_name; # название модели
    }
    else { die "Invalid value for: model_name!"; }

    if ( $speed =~ /^\d+$/ ) {
         $self->{ speed } = $speed; # скорость
    }
    else { die "Invalid value for: speed!"; }

    if ( $armor =~ /^\d+$/ ) {
         $self->{ armor } = $armor; # толщина брони
    }
    else { die "Invalid value for: armor!"; }

    if ( $strength =~ /^\d+$/ ) {
         $self->{ strength } = $strength; # прочность
    }
    else { die "Invalid value for: strength!"; }

    if ( $type =~ /tank/i && $weapon =~ /^cannon$|^machine_gun$/ ) {
         $self->{ weapon } = $weapon; # прочность
    }
    elsif ( $type =~ /plane/i && $weapon =~ /^rocket$|^machine_gun$/ ) {
            $self->{ weapon } = $weapon; # оружие
    }
    else {
            die "Invalid value for: weapon!";
    }
    
    bless $self, $class;
    
    if ( $type =~ /tank/i ) {
         say $self-> { type }, " took the position.";
    }
    elsif ( $type =~ /plane/i ) {
            say  say $self-> { type }, " took off.";
    }

    return $self;
}

sub get_set_speed {
    my ( $self, $speed ) = @_;

    if ( defined $speed ) { 
         if ( $speed =~ /^\d+$/ ) {
              return $self->{ speed } = $speed;
         }
         else { die "Invalid value for: speed!"; }
    }
    else { return $self->{ speed }; }
}

sub get_set_strength {
    my ( $self, $strength ) = @_;

    if ( defined $strength ) { 
         if ( $strength =~ /^\d+$/ ) {
              return $self->{ strength } = $strength;
         }
         else { die "Invalid value for: strength!"; }
    }
    else { return $self->{ strength }; }
}

sub moving {
    my $self = shift;

    if ( $self->{ type } =~ /tank/i ) {
         say riding( $self );
    }
    elsif ( $self->{ type } =~ /plane/i ) {
         say flying( $self );
    }
}

sub ride_the_ground {
    my $self = shift;

    return $self->{ type}, " rides the ground.";
}

sub flying {
    my $self = shift;

    unless ( $self->{ type } =~ /plane/i  ) {
             return DESTROY( $self );
    }

    return $self->{ type }, " is flying.";
}

sub get_hit {
    my ( $self, $damage ) = @_;
    $self->{ strength } -= $damage;
    my $destroy_probability = int( rand( 10 ) );

    if ( $self->{ strength } <= 0 || $destroy_probability == 5) { 
         return DESTROY( $self ); 
    }

    return $self->{ strength };
}

sub DESTROY {
    my $self = shift;

    return $self->{ type }, " destroyed!";
}

sub fire_cannon {
    my $self = shift;

    if ( $self->{ weapon } =~ /^cannon$/) {
         return $self->{ weapon }, " shoot!";
    }
    else { return $self->{ type }, " does not have a cannon!"; }
}

sub fire_machine_gun {
    my $self = shift;

    if ( $self->{ weapon } =~ /^machine_gun$/) {
         return $self->{ weapon }, " shoot!";
    }
    else { return $self->{ type }, " does not have a machine_gun!"; }
}

sub fire_rocket {
    my $self = shift;

    if ( $self->{ weapon } =~ /^rocket$/) {
         return $self->{ weapon }, " shoot!";
    }
    else { return $self->{ type }, " does not have a rocket!"; }
}

1;