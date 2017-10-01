# Бекенд для работы с БД
package BackendDb;

use Modern::Perl;
use Exporter; # модуль для управления внешним интерфейсом BackendDb
use DBI;

my @ISA = "Exporter"; # массив для наследования методов
my @EXPORT = "process_request"; # массив для создания синонима при импорте модуля

sub process_request {
    my ( $url ) = @_;
    $/ = undef; # присвоить значение undef для получения всех строк из файла

    if ( $url =~ /\/catalog$/ ) { # если запрошен весь каталог
         return read_catalog( ); # читаем каталог
    }
    elsif ( $url =~ /\/catalog\/([a-z]*[%20]*[a-z]*)$/i ) { # если запрошен конкретный автор
         return search_author( $1 ); # фильтруем каталог по автору
    }
    elsif ( $url =~ /\/catalog\/([a-z]*[%20]*[a-z]*)\/date_asc$/i ) { # если запрошен автор и фильтрация по дате написания
         return search_author_sort_data_writing( $1 ); # фильтруем каталог по автору и дате написания
    }
    elsif ( $url =~ /\/orders\/([a-z]*)$/i ) { # если запрошено хранилище пользователя
         return read_user_repository( $1 ); # читаем хранилище пользователя
    }
    elsif ( $url =~ /\/orders\/([a-z]*)\/new\/(.+)$/i ) { # если формируется новый заказ
         return write_user_repository( $1, $2 ); # обрабатываем новый заказ
    }
}

sub get_db_handler {
    return ( DBI->connect( "DBI:mysql:books", "user", "password" )
           or die "Error connecting to database" );
}

sub read_catalog {
    my $dbh = get_db_handler;
    
    my $sth = $dbh->prepare( "SELECT * FROM catalog" );

    $sth->execute;

    my $db_data = $sth->fetchall_arrayref({});

    return @$db_data;
}

sub search_author {
    my ( $author ) = @_;
    my @catalog = read_catalog( );
    my $size_catalog = scalar @catalog;
    $author =~ s/%20/ /; # заменяем %20 на пробел
    my @sort_catalog;

    for ( my $i = 0; $i < $size_catalog; $i++ ) { # ищем в каталоге запрошенного автора
          if ( $catalog[$i]->{ "author" } =~ /$author/i ) { # если автор присутствует
               push @sort_catalog, $catalog[$i]; # добавляем элемент в конечный массив
          }
    }

    return @sort_catalog;
}

sub search_author_sort_data_writing {
    my ( $author ) = @_;
    my @catalog = search_author( $author );
    
    @catalog = sort { # отсортировать каталог по дате написания в порядке возрастания
                     $a->{ "date_of_writing" }<=>
                     $b->{ "date_of_writing" }
                    } @catalog;
    
    return @catalog;
}

sub read_user_repository {
    my ( $user ) = @_;
    my $dbh = get_db_handler;
    
    my $sth = $dbh->prepare( "SELECT * 
                                FROM user_orders
                               INNER JOIN catalog
                                  ON user_orders.isbn = catalog.isbn
                               WHERE user_orders.name = '$user'" );

    $sth->execute;

    my $db_data = $sth->fetchall_arrayref({});
          
    if ( defined $db_data->[0] ) { # если хранилище пользователя не пустое
         return @$db_data; # возвращаем массив с хранилищем
    }
    else { # если хранилище пользователя пустое
         return "User repository is empty."; # возвращаем сообщение
    }
}

sub write_user_repository {
    my ( $user, $isbn ) = @_;
    my @catalog = read_catalog( );
    my $size_catalog = scalar @catalog;
    
    my @new_catalog; # переменная для хранения нового заказа
    my $i;

    for ( $i = 0; $i < $size_catalog; $i++ ) {  # проверяем наличие нового заказа в каталоге
          if ( $catalog[$i]->{ "isbn" } eq $isbn ) { # если новый заказ присутсвует
               push @new_catalog, $catalog[$i]; # добавляем заказ в массив
          }
    }

    if ( @new_catalog == 0 ) { return "nop"; } # если массив с заказом пустой возвращаем nop
    
    my @user_catalog = read_user_repository( $user );
    my $size_user_catalog = scalar @user_catalog;

    for ( $i = 0; $i < $size_user_catalog; $i++ ) { # проверяем наличие нового заказа в хранилище пользователя
          if ( $user_catalog[0] ne "User repository is empty." && $user_catalog[$i]->{ "isbn" } eq $isbn ) { # если новый заказ уже есть в хранилище
               return "yep"; # возвращаем yep
          }

    push @user_catalog, @new_catalog;
    my $ref_catalog = \@user_catalog;

    my $dbh = get_db_handler;
    
    $dbh->do( "INSERT INTO user_orders( name, isbn, new_order ) VALUES( '$user', '$isbn', 'yes' )" );

    return "yep";
    }
}

1;
