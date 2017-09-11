package crewmember; 
use Modern::Perl;

sub new {
	my ( $class, %args ) = @_; # получить переданные аргументы
	my $self = \%args;
	
	bless( $self, $class );
	
	return $self;
}

sub get_name {
	my ( $self, $value ) = @_;
	$self->{name} = $value if defined $value;
	
	return $self->{name};
}

sub AUTOLOAD {
	my @margins = ( "full_name", "rank" );
	our $AUTOLOAD;
}
1;