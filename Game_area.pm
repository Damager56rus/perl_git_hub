package Game_area;

use Modern::Perl;
use DBI;

sub new {
	my ( $class, $number, $size_x, $size_y , $id ) = @_;
	my $self = { };

	if ( $number =~ /^\d+$/ ) {
		 $self->{number} = $number;
	}
	else { die "Invalid value for number!"; }

	if ( $size_x =~ /^\d+$/ ) {
		 $self->{size_x} = $size_x;
	}
	else { die "Invalid value for size_x!"; }

	if ( $size_y =~ /^\d+$/ ) {
		 $self->{size_y} = $size_y;
	}
	else { die "Invalid value for size_y!"; }

	bless $self, $class;

	my $request = "INSERT INTO game_area( number, size_x, size_y ) 
	               VALUES( '$self->{number}', '$self->{size_x}', '$self->{size_y}' )";
    
    db_write_area( $self, $request );
	
	return $self;
}

sub db_connect {
	my $dbh = DBI->connect( 'DBI:mysql:locations', 'user', 'password' )
       or die "Error connecting to database";
    
    return $dbh;
}

sub db_read_area {
    my ( $class, $id ) = @_;
    my $dbh = db_connect( );
    my $sth = $dbh->prepare( "SELECT * FROM game_area WHERE id = '$id'" );
    
    $sth->execute;
    
    my $db_data = $sth->fetchrow_hashref;
    
    $sth->finish;
    
    $dbh->disconnect;

    bless $db_data, $class;

    return $db_data;
}

sub db_write_area {
    my ( $self, $request ) = @_;
    my $dbh = db_connect( );
    my $sth = $dbh->prepare( $request ); # подготовить запрос к выполнению
    
    $sth->execute;

    $dbh->disconnect;
}

sub list_of_areas {
    my $dbh = db_connect( );
    my $sth = $dbh->prepare( "SELECT * FROM game_area" );
    
    $sth->execute;
    
    while ( my $db_data = $sth->fetchrow_hashref ) {
            say "---Game_area---";
            say "id: ", $db_data->{id};
            say "number: ", $db_data->{number};
            say "size_x: ", $db_data->{size_x};
            say "size_y: ", $db_data->{size_y};
    }

    $sth->finish;
    
    $dbh->disconnect;
}

sub get_area_info {
	my $self = shift;

    say "id: ", $self->{id};
	say "number: ", $self->{number};
	say "size_x: ", $self->{size_x};
	say "size_y: ", $self->{size_y};
}

sub get_id {
	my $self = shift;

	return $self->{id};
}

sub get_number {
	my $self = shift;
	
	return $self->{number};
}

sub set_number {
	my ( $self, $number ) = @_;
	my $request = "UPDATE game_area SET number = '$number' WHERE id = '$self->{id}'";

	if ( $number =~ /^\d+$/ ) {
		 
         db_write_area( $self, $request );

		 return $self->{number} = $number;
	}
	else { die "Invalid value for number!"; }
}

sub get_size_x {
	my $self = shift;
	
	return $self->{size_x};
}

sub set_size_x {
	my ( $self, $size_x ) = @_;
	my $request = "UPDATE game_area SET size_x = '$size_x' WHERE id = '$self->{id}'";

	if ( $size_x =~ /^\d+$/ ) {
		 
         db_write_area( $self, $request );

		 return $self->{size_x} = $size_x;
	}
	else { die "Invalid value for size_x!"; }
}

sub get_size_y {
	my $self = shift;
	
	return $self->{size_y};
}

sub set_size_y {
	my ( $self, $size_y ) = @_;
	my $request = "UPDATE game_area SET size_y = '$size_y' WHERE id = '$self->{id}'";

	if ( $size_y =~ /^\d+$/ ) {
		 
         db_write_area( $self, $request );

		 return $self->{size_y} = $size_y;
	}
	else { die "Invalid value for size_y!"; }
}

sub get_size {
	my $self = shift;
	my $size_x = get_size_x( $self );
	my $size_y = get_size_y( $self );
	
	return $size_x, $size_y;
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