#!/usr/bin/perl
# Юнит-тестирование бекенда с помощью Test::Spec

use Test::Spec;
use Modern::Perl;
use BackendDb;

describe "Backend_db" => sub {
          describe "Used modules" => sub {
                    it "should use Exporter" => sub {
                        use_ok( 'Exporter' );
                    };
                    
                    it "should use DBI" => sub {
                        use_ok( 'DBI' );
                    };
          };

          describe "process_request" => sub {
                    it "should return: all catalog data" => sub {
                        BackendDb->stubs( read_catalog => 'all catalog data' );

                        is( BackendDb::process_request( '/catalog' ), 'all catalog data' );
                    };
                    
                    it "should return: sorted by Platon catalog" => sub {
                        BackendDb->stubs( search_author => 'sorted by Platon catalog' );

                        is( BackendDb::process_request( '/catalog/platon' ), 
                        	'sorted by Platon catalog' );
                    };
                    
                    it "should return: sorted by Platon and data writing catalog" => sub {
                        BackendDb->stubs( search_author_sort_data_writing => 
                        	             'sorted by Platon and data writing catalog' );

                        is( BackendDb::process_request( '/catalog/platon/date_asc' ), 
                        	'sorted by Platon and data writing catalog' );
                    };
                    
                    it "should return: Aristotel repository data" => sub {
                        BackendDb->stubs( read_user_repository => 'Aristotel repository data' );

                        is( BackendDb::process_request( '/orders/aristotel' ), 
                        	'Aristotel repository data' );
                    };

                    it "should return: new order in Aristotel repository" => sub {
                        BackendDb->stubs( write_user_repository => 'new order in Aristotel repository' );

                        is( BackendDb::process_request( '/orders/aristotel/new/123-1234' ), 
                        	'new order in Aristotel repository' );
                    };
          };

          describe "search_author" => sub {
                    it "should return: sorted by Platon catalog" => sub {
                        my @catalog;
                        $catalog[0] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };
                        $catalog[1] = {
                             author => 'Carl Marx',
                             name => 'Capital',
                             date_of_writing => '1867',
                             publishing_house => ' Otto Karl Meisner, Germany',
                             isbn => '553-3831',
                        };

                        BackendDb->expects( 'read_catalog' )->returns( @catalog );

                        my @sorted_catalog;
                        $sorted_catalog[0] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };

                        my $ref_sorted_catalog = \@sorted_catalog;
                        my @result = BackendDb::search_author( 'Platon' );
                        my $ref_result = \@result;
                        
                        is_deeply( $ref_result, $ref_sorted_catalog );
                    };
          };
          
          describe "search_author_sort_data_writing" => sub {
                    it "should return: sorted by Platon and data writing catalog" => sub {
                        my @catalog;
                        $catalog[0] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };
                        $catalog[1] = {
                             author => 'Platon',
                             name => 'Feast',
                             date_of_writing => '-360',
                             publishing_house => 'Korinf, Ancient Greece',
                             isbn => '123-2684',
                        };

                        BackendDb->expects( 'search_author' )->returns( @catalog );

                        my @sorted_catalog;
                        $sorted_catalog[0] = {
                             author => 'Platon',
                             name => 'Feast',
                             date_of_writing => '-360',
                             publishing_house => 'Korinf, Ancient Greece',
                             isbn => '123-2684',
                        };
                        $sorted_catalog[1] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };

                        my $ref_sorted_catalog = \@sorted_catalog;
                        my @result = BackendDb::search_author_sort_data_writing( 'Platon' );
                        my $ref_result = \@result;

                        is_deeply( $ref_result, $ref_sorted_catalog );
                    };
          };

          describe "read_user_repository" => sub {
                    it "should return: Aristotel repository data." => sub {
                        my @user_catalog;
                        $user_catalog[0] = {
                             author => 'Platon',
                             name => 'Feast',
                             date_of_writing => '-360',
                             publishing_house => 'Korinf, Ancient Greece',
                             isbn => '123-2684',
                        };
                        
                        my $ref_user_catalog = \@user_catalog;
                        my $DBI_mock = stub();
                        
                        $DBI_mock->stubs( prepare => stub( 'execute' => 1, 'fetchall_arrayref' => $ref_user_catalog ) );
                        BackendDb->stubs( get_db_handler => $DBI_mock );

                        is( BackendDb::read_user_repository( 'aristotel' ), @$ref_user_catalog );
                    };

                    it "should return: User repository is empty." => sub {
                        my $DBI_mock = stub();
                        
                        $DBI_mock->stubs( prepare => stub( 'execute' => 1, 'fetchall_arrayref' => undef ) );
                        BackendDb->stubs( get_db_handler => $DBI_mock );

                        is( BackendDb::read_user_repository( 'aristotel' ), 'User repository is empty.' );
                    };
          };

          describe "write_user_repository" => sub {
                    it "should return: nop" => sub {
                        my @catalog;
                        $catalog[0] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };
                        $catalog[1] = {
                             author => 'Carl Marx',
                             name => 'Capital',
                             date_of_writing => '1867',
                             publishing_house => ' Otto Karl Meisner, Germany',
                             isbn => '553-3831',
                        };

                        BackendDb->expects( 'read_catalog' )->returns( @catalog );

                        is( BackendDb::write_user_repository( 'aristotel', '123-2345' ), 'nop' );
                    };

                    it "should return: yep" => sub {
                        my @catalog;
                        $catalog[0] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };
                        $catalog[1] = {
                             author => 'Carl Marx',
                             name => 'Capital',
                             date_of_writing => '1867',
                             publishing_house => ' Otto Karl Meisner, Germany',
                             isbn => '553-3831',
                        };

                        my @user_catalog;
                        $user_catalog[0] = {
                             author => 'Platon',
                             name => 'Laws',
                             date_of_writing => '-354',
                             publishing_house => 'Crete, Ancient Greece',
                             isbn => '123-1234',
                        };

                        BackendDb->expects( 'read_catalog' )->returns( @catalog );
                        BackendDb->expects( 'read_user_repository' )->returns( @user_catalog );

                        is( BackendDb::write_user_repository( 'aristotel', '123-1234' ), 'yep' );
                    };
          };
};

runtests unless caller;