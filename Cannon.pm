package Cannon;

use Modern::Perl;

sub new {
	my ( $class, $type, $ammunition_amount ) = @_;
	my $self = { };

    if ( $type =~ /^cannon$|^machine_gun$|^rocket$/i ) {
         $self->{ type } = $type; # тип вооружения
    }
    else { die "Invalid value for: type!"; }

    if ( $ammunition_amount =~ /^\d+$/ ) {
         $self->{ ammunition_amount } = $ammunition_amount; # количество боеприпасов
    }
    else { die "Invalid value for: ammunition_amount!"; }

	bless $self, $class;

    return $self;
}

sub take_aim {
    my $self = shift;

    return $self->{ type }, " taking aim!";
}

sub fire {
    my $self = shift;

    if ( $self->{ ammunition_amount } > 0 ) {
    	 $self->{ ammunition_amount } -= 1;
    	 return recharge( $self );
    }
    else {
    	 die "Not enough ammunition_amount!";
    }
}

sub recharge {
    my $self = shift;
    
    return $self->{ type }, " is reloaded!";
}

1;