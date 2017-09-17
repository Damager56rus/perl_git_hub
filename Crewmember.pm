package Crewmember; 
use Modern::Perl;

sub new {
	my ( $class, $full_name, $rank, $speciality, $term_of_work, $study_model ) = @_;
	my $self = { 
		          full_name => $full_name,
		               rank => $rank,
		         speciality => $speciality, 
		       term_of_work => $term_of_work,
		        study_model => $study_model
		       };
	
	bless( $self, $class );
	
	return $self;
}

sub AUTOLOAD {
	my $value = shift;
	our $AUTOLOAD;
	( my $method = $AUTOLOAD ) =~ s/.*:://;
	
	if ( $method eq "get_set_fullname" ) {
		 get_set_fullname( @_ );
	}
	if ( $method eq "get_set_rank" ) {
		 get_set_rank( @_ );
	}
	if ( $method eq "get_set_speciality" ) {
		 get_set_speciality( @_ );
	}
	if ( $method eq "get_set_term_of_work" ) {
		 get_set_term_of_work( @_ );
	}
	if ( $method eq "get_set_study_model" ) {
		 get_set_study_model( @_ );
	}
	else { die "Not method in class Crewmember"; }
}

sub get_set_fullname {
	my ( $self, $value ) = @_;
    if ( defined $value ) {
    	 if ( $value =~ /[a-z]* [a-z]* [a-z]*/i ) {
    	      $self->{ name } = $value;

    	      return $self->{ name };
    	 }
	     else {
	     	  die "Invalid fullname!";
	     }
    }
    else {
	     return $self->{ full_name };
	}
}

sub get_set_rank {
	my ( $self, $value ) = @_;
    if ( defined $value ) {
    	 if ( $value =~ /\w+/i ) {
    	      $self->{ rank } = $value;

    	      return $self->{ rank };
    	 }
	     else {
	     	  die "Invalid rank!";
	     }
    }
    else {
	     return $self->{ rank };
	}
}

sub get_set_speciality {
	my ( $self, $value ) = @_;
    if ( defined $value ) {
    	 if ( $value =~ /commander/ ) {
    	      $self->{ speciality } = $value;

    	      return $self->{ speciality };
    	 }
	     else {
	     	  die "Invalid speciality!";
	     }
    }
    else {
	     return $self->{ speciality };
	}
}

sub get_set_term_of_work {
	my ( $self, $value ) = @_;
    if ( defined $value ) {
    	if ( $value =~ /d+ years/ ) {
    	      $self->{ term_of_work } = $value;

    	      return $self->{ term_of_work };
    	 }
	     else {
	     	  die "Invalid speciality!";
	     }
    }
    else {
	     return $self->{ term_of_work };
	}
}

sub get_set_study_model {
	my ( $self, $value ) = @_;
    if ( defined $value ) {
    	 $self->{ study_model } = $value;
	
	     return $self->{ study_model };
    }
    else {
	     return $self->{ study_model };
	}
}

1;