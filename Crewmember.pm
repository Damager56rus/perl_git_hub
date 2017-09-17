# Практика по ООП №1
package Crewmember; 

use Modern::Perl;

sub new {
	my ( $class, $fullname, $rank, $speciality, $experience, $study_model ) = @_;
	my $self = { 
		           fullname => $fullname, # ФИО
		               rank => $rank, # звание
		         speciality => $speciality, # специальность
		         experience => $experience, # срок службы
		        study_model => $study_model # изученная модель техники
		       };
	
	bless( $self, $class );
	
	return $self;
}

sub AUTOLOAD {
	our $AUTOLOAD;
	( my $method = $AUTOLOAD ) =~ s/.*:://;
    my @fields = ( 'fullname', 'rank', 'speciality', 'experience', 'study_model' );
    my $size_fields = scalar @fields;
    my $i;
    my $validation_template; # хранение шаблона для валидации

    for ( $i = 0; $i < $size_fields; $i++ ) {
	      
	      if ( $method eq 'get_set_' . $fields[$i] ) { # если метод содержит get_set_$fields[$i]
	           eval q { # определить метод для работы с полями
		 	           sub get_set_field {
	                       my ( $self, $value ) = @_;
                                
                                if ( defined $value ) { # если было передано значение
    	                             
    	                             if ( $i == 0 ) { # определить шаблон для валидации
    	                             	  $validation_template = '[a-z]* [a-z]* [a-z]*';
    	                             }
    	                             elsif( $i == 1 or $i == 4 ) {
                                            $validation_template = '\w+';
    	                             }
    	                             elsif( $i == 2 ) {
    	                             	    $validation_template = '^commander$|^driver-mechanic$|^gunner$|^charging$|^radio-operator$';
    	                             }
    	                             elsif( $i == 3 ) {
                                            $validation_template = '^\d+ years$';
    	                             }
    	                             
    	                             if ( $value =~ /$validation_template/i ) { # если валидация пройдена
    	                                  $self->{ $fields[$i] } = $value;

    	                                  return $self->{ $fields[$i] };
    	                             }
	                                 else {
	     	                              die "Invalid value for:", " ", $fields[$i], "!";
	                                 }
                                }
                                
                                else { # если значение не было передано
	                                 return $self->{ $fields[$i] };
	                            }
                       }
		       };
		  
		  goto &get_set_field;
	      }
	}

	die "No method in the class!"; # если запрашиваемый метод не был найден
}

1;
