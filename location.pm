package location;

use Modern::Perl;
use Moose;

has ['number', 'size_x', 'size_y' ] => ( is => 'rw', isa => 'Int' );

sub create_object {
	my ( $name, $coordinate_x, $coordinate_y ) = @_;
	has ['name', 'coordinate_x', 'coordinate_y' ] => ( is => 'rw', isa => 'Int' );
}

1;