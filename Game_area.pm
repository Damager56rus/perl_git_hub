package Game_area;

use Modern::Perl;

sub new {
	my ( $class, $number, $size_x, $size_y ) = @_;
	my $self = { };

	if ( $number =~ /^\d+$/ ) {
		 $self->{ number } = $number;
	}
	else { die "Invalid value for number!"; }

	if ( $size_x =~ /^\d+$/ ) {
		 $self->{ size_x } = $size_x;
	}
	else { die "Invalid value for size_x!"; }

	if ( $size_y =~ /^\d+$/ ) {
		 $self->{ size_y } = $size_y;
	}
	else { die "Invalid value for size_y!"; }

	bless $self, $class;
	
	return $self;
}

sub get_number {
	my $self = shift;
	
	return $self->{ number };
}

sub get_size_x {
	my $self = shift;
	
	return $self->{ size_x };
}

sub get_size_y {
	my $self = shift;
	
	return $self->{ size_y };
}

sub spawn_enimes {
	my $self = shift;
    my $spawn_variants = int( rand( 8 ) );
    my $minimum_rand;
	my $maximum_rand;

    if ( $spawn_variants <= 5 ) {
    	 #$log = $log->info( "Spawn|No spawn in this stroke." );
    	 return "No spawn";
    }
    elsif ( $spawn_variants == 6 ) {
    	    $minimum_rand = 1;
    	    $maximum_rand = 4;
    	    $_ = int( $minimum_rand + rand( $maximum_rand - $minimum_rand ) );
    	    
    	    return "$_ enimes spawned!";

    }
    elsif ( $spawn_variants == 7 ) {
    	    $minimum_rand = 10;
    	    $maximum_rand = 50;
            $_ = int( $minimum_rand + rand( $maximum_rand - $minimum_rand ) );

            return "Collision with a meteor! Damage is: $_";
    }
}

1;