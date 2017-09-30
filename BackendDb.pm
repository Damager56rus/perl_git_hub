# Модуль бекенд для Perl Web-Server
package BackendDb; # задать имя модуля

# Подключить модули для
use Modern::Perl; # ужесточения автоматического контроля 
use Exporter; # управления внешним интерфейсом модуля BackendDb
use DBI; # работы с БД

# Объявить переменные для
my @ISA = "Exporter"; # наследования методов
my @EXPORT = "process_request"; # создания синонима при импорте модуля

sub process_request {
    my ( $url ) = @_; # получить переданные аргументы
    $/ = undef; # присвоить значение undef для получения всех строк из файла

    if ( $url =~ /\/catalog$/ ) {
         return read_catalog( ); # прочитать каталог
    }
    elsif ( $url =~ /\/catalog\/([a-z]*[%20]*[a-z]*)$/i ) {
         return search_author( $1 ); # отфильтровать каталог по автору
    }
    elsif ( $url =~ /\/catalog\/([a-z]*[%20]*[a-z]*)\/date_asc$/i ) {
         return search_author_sort_data_writing( $1 ); # отфильтровать по автору и дате написания
    }
    elsif ( $url =~ /\/orders\/([a-z]*)$/i ) {
         return read_user_repository( $1 ); # прочитать хранилище пользователя
    }
    elsif ( $url =~ /\/orders\/([a-z]*)\/new\/(.+)$/i ) {
         return write_user_repository( $1, $2 ); # записать новый заказ в хранилище
    }
} 

sub read_catalog {
    my $dbh = DBI->connect( "DBI:mysql:books", "user", "password" ) # соединиться с БД
       or die "Error connecting to database";
    
    my $sth = $dbh->prepare( "SELECT * FROM catalog" ); # подготовить запрос к выполнению
    $sth->execute; # выполнить запрос
    my $db_data = $sth->fetchall_arrayref({}); # получить данные из БД
    
    $dbh->disconnect; # отсоединиться от БД

    return @$db_data; # вернуть массив с каталогом
}

sub search_author {
    my ( $author ) = @_; # получить переданные аргументы
    my @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog; # определить размер каталога
    $author =~ s/%20/ /; # заменить %20 на пробел
    my @sort_catalog;

    for ( my $i = 0; $i < $size_catalog; $i++ ) { # найти в каталоге запрошенного автора
          if ( $catalog[$i]->{ "author" } =~ /$author/i ) { # если автор присутствует
               push @sort_catalog, $catalog[$i]; # добавить элемент в конечный массив
          }
    }

    return @sort_catalog; # вернуть массив с отсортированным по автору каталогом
}

sub search_author_sort_data_writing {
    my ( $author ) = @_;  # получить переданные аргументы
    my @catalog = search_author( $author ); # получить отсортированный по автору каталог
    
    @catalog = sort { # отсортировать каталог по дате написания в порядке возрастания
                     $a->{ "date_of_writing" }<=>
                     $b->{ "date_of_writing" }
                    } @catalog;
    
    return @catalog; # вернуть отсортированный массив
}

sub read_user_repository {
    my ( $user ) = @_; # получить переданные аргументы
    my $dbh = DBI->connect( "DBI:mysql:books", "user", "password" ) # соединиться с БД
              or die "Error connecting to database";
    
    my $sth = $dbh->prepare( "SELECT * 
                                FROM user_orders
                               INNER JOIN catalog
                                  ON user_orders.isbn = catalog.isbn
                               WHERE user_orders.name = '$user'" ); # подготовить запрос к выполнению
    $sth->execute; # выполнить запрос
    my $db_data = $sth->fetchall_arrayref({}); # получить данные из БД
    
    $dbh->disconnect; # отсоединиться от БД
          
    if ( defined $db_data->[0] ) { # если хранилище пользователя не пустое
         return @$db_data; # вернуть массив с хранилищем
    }
    else { # если хранилище пользователя пустое
         return "User repository is empty."; # вернуть массив с сообщением
    }
}

sub write_user_repository {
    my ( $user, $isbn ) = @_; # получить переданные аргументы
    my @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog; # определить размер каталога
    
    # Объявить переменные для
    my @new_catalog; # хранения нового заказа
    my $i; # использования цикла

    for ( $i = 0; $i < $size_catalog; $i++ ) {  # проверить наличие нового заказа в каталоге
          if ( $catalog[$i]->{ "isbn" } eq $isbn ) { # если новый заказ присутсвует в каталоге
               push @new_catalog, $catalog[$i];
          }
    }

    if ( @new_catalog == 0 ) { return "nop"; } # если массив с заказом пустой вернуть сообщение nop
    
    my @user_catalog = read_user_repository( $user ); # прочитать хранилище пользователя
    my $size_user_catalog = scalar @user_catalog; # определить размер хранилища

    for ( $i = 0; $i < $size_user_catalog; $i++ ) { # проверить наличие нового заказа в хранилище пользователя
          if ( $user_catalog[0] ne "User repository is empty." && $user_catalog[$i]->{ "isbn" } eq $isbn ) { # если новый заказ уже есть в хранилище
               return "yep"; # вернуть сообщение yep
          }

    push @user_catalog, @new_catalog; # объединить массивы с хранилищем и заказом для записи
    my $ref_catalog = \@user_catalog; # создать ссылку на конечный массив

    my $dbh = DBI->connect( "DBI:mysql:books", "user", "password" ) # соединиться с БД
              or die "Error connecting to database";
    
    my $sth = $dbh->prepare( "INSERT INTO user_orders( name, isbn, new_order ) VALUES( '$user', '$isbn', 'yes' )" ); # подготовить запрос к выполнению
    $sth->execute; # выполнить запрос
  
    $dbh->disconnect; # отсоединиться от БД

    return "yep"; # вернуть сообщение yep
    }
}

# Вернуть 1
1;
