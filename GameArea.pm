package SpaceLife::Modules::GameArea;

use Modern::Perl;
use DBIx::Simple;
use Mojo::Base 'Mojolicious';
use SpaceLife::DbConfig;

my $dbh = $SpaceLife::DbConfig::db_conn;

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

	my $query = "INSERT INTO game_area( number, size_x, size_y ) 
	               VALUES( '$self->{number}', '$self->{size_x}', '$self->{size_y}' )";
    
    make_query_to_db( $self, $query );
	
	return $self;
}

sub read_area_from_db {
    my ( $class, $id ) = @_;
    my $query = "SELECT * FROM game_area WHERE id = $id";
    my $db_data = make_query_to_db( $class, $query )->hash;

    bless $db_data, $class;

    return $db_data;
}

sub make_query_to_db {
    my ( $self, $query ) = @_;

    $dbh->query( $query ) or die $dbh->error;
}

sub list_of_created_areas {
    my $result = $dbh->query( "SELECT * FROM game_area" ) or die $dbh->error;
    
    while ( my $db_data = $result->hash ) {
            say "---GameArea---";
            say "id: ", $db_data->{id};
            say "number: ", $db_data->{number};
            say "size_x: ", $db_data->{size_x};
            say "size_y: ", $db_data->{size_y};
    }
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
	my $query = "UPDATE game_area SET number = '$number' WHERE id = '$self->{id}'";

	if ( $number =~ /^\d+$/ ) {
		 
         make_query_to_db( $self, $query );

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
	my $query = "UPDATE game_area SET size_x = '$size_x' WHERE id = '$self->{id}'";

	if ( $size_x =~ /^\d+$/ ) {
		 
         make_query_to_db( $self, $query );

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
	my $query = "UPDATE game_area SET size_y = '$size_y' WHERE id = '$self->{id}'";

	if ( $size_y =~ /^\d+$/ ) {
		 
         make_query_to_db( $self, $query );

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

sub delete_game_area_from_db {
	my $self = shift;

	my $query = "DELETE FROM game_area WHERE id = '$self->{id}'";
		 
    make_query_to_db( $self, $query );
}

sub spawn_enimes {
	my $self = shift;
    my $spawn_variants = int( rand( 8 ) );
    my $minimum_rand;
	my $maximum_rand;

    if ( $spawn_variants <= 5 ) {
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
