# Практика по ООП №2
package Weapon_type;
use Modern::Perl;

sub new {
	my ( $class, $type, $ammunition_amount, $magazin ) = @_;
	my $self = { };

    if ( $type =~ /^cannon$|^machine_gun$|^rocket$/i ) {
         $self->{ type } = $type; # тип вооружения
    }
    else { die "Invalid value for: type!"; }

    if ( $ammunition_amount =~ /^\d+$/ ) {
         $self->{ ammunition_amount } = $ammunition_amount; # количество боеприпасов
    }
    else { die "Invalid value for ammunition_amount!"; }

    if ( $type =~ /^machine_gun$/i ) {
         $self->{ magazin } = 10; # размер магазина пулемета
    }
    elsif ( $type =~ /^cannon$/i || $type =~ /^rocket$/i ) {
            $self->{ magazin } = 0; # нулевой размер магазина для пушки и рокеты
    }

	bless $self, $class;

    say $self->{ type }, " is mounted."; # установить оружие на технику

    return $self;
}

sub take_aim {
    my $self = shift;

    return say $self->{ type }, " taking aim!"; # прицелиться
}

sub fire {
    my $self = shift;

    if ( $self->{ ammunition_amount } > 0 ) { # если есть боеприпасы
    	 say $self->{ type }, " fired!";
         say "Ammunition_amount is: ", $self->{ ammunition_amount } -= 1;
    	 
    	 if ( $self->{ type } =~ /^machine_gun$/i ) { # если стреляем из пулемета
    	      $self->{ magazin } -= 1;

    	      return say recharge( $self ); # проверить необходимость перезарядки
    	 }
    	 elsif ( $self->{ type } =~ /^cannon$/i ) {
                 return say recharge( $self );
    	 }
    }
    else { # если боеприпасы закончились
    	 die "Not enough ammunition_amount!";
    }
}

sub recharge {
    my $self = shift;
    
    if ( $self->{ magazin } == 0 ) { # перезарядить магазин для пулемета
         if ( $self->{ type } =~ /^machine_gun$/i ) {
         	  $self->{ magazin } = 10;
         }
         
         return $self->{ type }, " is reloaded!";
    }
}

1;