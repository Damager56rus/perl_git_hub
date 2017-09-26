package Location_object;

use Modern::Perl;
use DBI;

sub new {
	my ( $class, $type, $name, $coordinate_x, $coordinate_y, $area_number, $id ) = @_;
	my $self = { };

    if ( $type =~ /^planet$|^station$/i ) {
		 $self->{type} = $type;
	}
	else { die "Invalid value for type!"; }

	if ( $name =~ /^\w+$/ ) {
		 $self->{name} = $name;
	}
	else { die "Invalid value for name!"; }

	if ( $coordinate_x =~ /^\d+$/ ) {
		 $self->{coordinate_x} = $coordinate_x;
	}
	else { die "Invalid value for coordinate_x!"; }

	if ( $coordinate_y =~ /^\d+$/ ) {
		 $self->{coordinate_y} = $coordinate_y;
	}
	else { die "Invalid value for coordinate_y!"; }

	if ( $area_number =~ /^\d+$/ ) {
		 $self->{area_number} = $area_number;
	}
	else { die "Invalid value for area_number!"; }

    my $request = "INSERT INTO location_object( type, name, coordinate_x, coordinate_y, area_number ) 
                   VALUES( '$self->{type}', '$self->{name}' ,'$self->{coordinate_x}', '$self->{coordinate_y}', '$self->{area_number}' )";
	db_write_object( $self, $request );

	bless $self, $class;
	
	return $self;
}

sub db_connect {
	my $dbh = DBI->connect( 'DBI:mysql:locations', 'root', 'w12345%@' )
       or die "Error connecting to database";
    
    return $dbh;
}

sub db_read_object {
    my ( $class, $id ) = @_;
    my $dbh = db_connect( );
    my $sth = $dbh->prepare( "SELECT * FROM location_object WHERE id = '$id'" );
    
    $sth->execute;
    
    my $db_data = $sth->fetchrow_hashref;
    
    $sth->finish;
    
    $dbh->disconnect;

    bless $db_data, $class;

    return $db_data;
}

sub db_write_object {
    my ( $self, $request ) = @_;
    my $dbh = db_connect( );
    my $sth = $dbh->prepare( $request ); # подготовить запрос к выполнению
    
    $sth->execute;
  
    $dbh->disconnect;
}

sub list_of_objects {
    my $dbh = db_connect( );
    my $sth = $dbh->prepare( "SELECT * FROM location_object" );
    
    $sth->execute;
    
    while ( my $db_data = $sth->fetchrow_hashref ) {
            say "---Location_object---";
            say "id: ", $db_data->{id};
            say "type: ", $db_data->{type};
            say "name: ", $db_data->{name};
            say "coordinate_x: ", $db_data->{coordinate_x};
            say "coordinate_y: ", $db_data->{coordinate_y};
            say "area_number: ", $db_data->{area_number};
    }

    $sth->finish;
    
    $dbh->disconnect;
}

sub get_object_info {
	my $self = shift;

    say "id: ", $self->{id};
	say "type: ", $self->{type};
	say "name: ", $self->{name};
	say "coordinate_x: ", $self->{coordinate_x};
	say "coordinate_y: ", $self->{coordinate_y};
	say "area_number: ", $self->{area_number};
}

sub get_id {
	my $self = shift;

	return $self->{id};
}

sub get_type {
	my $self = shift;
	
	return $self->{type};
}

sub set_type {
	my ( $self, $type ) = @_;
	my $request = "UPDATE location_object SET type = '$type' WHERE id = '$self->{id}'";

	if ( $type =~ /^planet$|^station$/i ) {
		 
         db_write_object( $self, $request );

		 return $self->{type} = $type;
	}
	else { die "Invalid value for type!"; }
}

sub get_name {
	my $self = shift;
	
	return $self->{name};
}

sub set_name {
	my ( $self, $name ) = @_;
	my $request = "UPDATE location_object SET name = '$name' WHERE id = '$self->{id}'";

	if ( $name =~ /^\w+$/ ) {
		 
         db_write_object( $self, $request );

		 return $self->{name} = $name;
	}
	else { die "Invalid value for name!"; }
}

sub get_coordinate_x {
	my $self = shift;
	
	return $self->{coordinate_x};
}

sub set_coordinate_x {
	my ( $self, $coordinate_x ) = @_;
	my $request = "UPDATE location_object SET coordinate_x = '$coordinate_x' WHERE id = '$self->{id}'";

	if ( $coordinate_x =~ /^\d+$/ ) {
		 
         db_write_object( $self, $request );

		 return $self->{coordinate_x} = $coordinate_x;
	}
	else { die "Invalid value for coordinate_x!"; }
}

sub get_coordinate_y {
	my $self = shift;
	
	return $self->{coordinate_y};
}

sub set_coordinate_y {
	my ( $self, $coordinate_y ) = @_;
	my $request = "UPDATE location_object SET coordinate_y = '$coordinate_y' WHERE id = '$self->{id}'";

	if ( $coordinate_y =~ /^\d+$/ ) {
		 
         db_write_object( $self, $request );

		 return $self->{coordinate_y} = $coordinate_y;
	}
	else { die "Invalid value for coordinate_y!"; }
}

sub get_coordinates {
	my $self = shift;
    my $coordinate_x = get_coordinate_x( $self );
    my $coordinate_y = get_coordinate_y( $self );

	return $coordinate_x, $coordinate_y;
}

sub get_area_number {
	my $self = shift;
	
	return $self->{area_number};
}

sub set_area_number {
	my ( $self, $area_number ) = @_;
	my $request = "UPDATE location_object SET area_number = '$area_number' WHERE id = '$self->{id}'";

	if ( $area_number =~ /^\d+$/ ) {
		 
         db_write_object( $self, $request );

		 return $self->{area_number} = $area_number;
	}
	else { die "Invalid value for area_number!"; }
}

sub move_by_object {
	my ( $self, $move_choice ) = @_;

    if ( $move_choice == 1 ) {
    	 return "Quests lists";
	}
	elsif ( $move_choice == 2 ) {
		    if ( $self->{type} =~ /^planet$/i ) {
		         return "Store price list";
		    }
		    else {
		    	 return "There is no store because it is a station!";
		    }
	}
	elsif ( $move_choice == 3 ) {
		    return "Ship flew away";
	}
}

1;