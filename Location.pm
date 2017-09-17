package Location;
use Modern::Perl;

sub new {
	my ( $class, $number, $size_x, $size_y ) = @_;
	my $self = { number => $number, size_x => $size_x, size_y => $size_y };
	
	bless $self, $class;
	
	return $self;
}

sub get_number {
	my ( $self ) = @_;
	
	return $self->{ number };
}

sub set_number {
	my ( $self, $number ) = @_;
	if ( $number =~ /\d/ ) {
         $self->{number} = $number;
	}
	else {
		 die "Invalid game_area number!";
	}
}

sub get_size_x {
	my ( $self ) = @_;
	
	return $self->{ size_x };
}

sub get_size_y {
	my ( $self ) = @_;
	
	return $self->{ size_y };
}

1;