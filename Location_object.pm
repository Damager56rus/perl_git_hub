package Location_object;

use Modern::Perl;

sub new {
	my ( $class, $name, $coordinate_x, $coordinate_y, $area_number ) = @_;
	my $self = { };

	if ( $name =~ /^\w+$/ ) {
		 $self->{ name } = $name;
	}
	else { die "Invalid value for name!"; }

	if ( $coordinate_x =~ /^\d+$/ ) {
		 $self->{ coordinate_x } = $coordinate_x;
	}
	else { die "Invalid value for coordinate_x!"; }

	if ( $coordinate_y =~ /^\d+$/ ) {
		 $self->{ coordinate_y } = $coordinate_y;
	}
	else { die "Invalid value for coordinate_y!"; }

	if ( $area_number =~ /^\d+$/ ) {
		 $self->{ area_number } = $area_number;
	}
	else { die "Invalid value for area_number!"; }

	bless $self, $class;
	
	return $self;
}

sub get_name {
	my $self = shift;
	
	return $self->{ name };
}

sub get_coordinate_x {
	my $self = shift;
	
	return $self->{ coordinate_x };
}

sub get_coordinate_y {
	my $self = shift;
	
	return $self->{ coordinate_y };
}

sub get_area_number {
	my $self = shift;
	
	return $self->{ area_number };
}

sub move_by_object {
	my ( $self, $move_choice ) = @_;

    if ( $move_choice == 1 ) {
    	 return "Quests lists";
	}
	elsif ( $move_choice == 2 ) {
		    return "Magazin price list";
	}
	elsif ( $move_choice == 3 ) {
		    return "Ship flew away";
	}
}

1;