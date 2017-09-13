# Модуль бекенд для Perl Web-Server
package backend; # задать имя модуля

# Подключить модули для
use Modern::Perl; # ужесточения автоматического контроля 
use Exporter; # управления внешним интерфейсом модуля backend
use JSON::XS; # работы с файлами формата JSON

# Объявить переменные для
my @ISA = "Exporter"; # наследования методов
my @EXPORT = "process_request"; # создания синонима при импорте модуля

sub process_request {
    my ( $url ) = @_; # получить переданные аргументы
    $/ = undef; # присвоить значение undef для получения всех строк из файла

    if ( $url =~ /\/catalog$/ ) {
         return read_catalog( ); # прочитать каталог
    }
    elsif ( $url =~ /\/catalog\/([a-z]*)$/i ) {
         return search_author( $1 ); # отфильтровать каталог по автору
    }
    elsif ( $url =~ /\/catalog\/([a-z]*)\/date_asc$/i ) {
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
    open FILEWORK, "<", "catalog.json" # открыть файл catalog.json
         or die "Can't open catalog.json: $!";
    
    my $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> ); # получить декодированные данные из файла
    close FILEWORK; # закрыть файл

    return @$json_data_decode; # вернуть каталог
}

sub search_author {
    my ( $author ) = @_; # получить переданные аргументы
    my @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog; # определить размер каталога
    $author =~ s/%20/ /; # заменить %20 на пробел
    
    for ( my $i = 0; $i < $size_catalog; $i++ ) { # найти в каталоге запрошенного автора
          unless ( $catalog[$i]->{ "Author" } =~ /$author/i ) { # если автор отсутствует
                   delete $catalog[$i]; # удалить из массива хеш без автора
          }
    }

    return @catalog; # вернуть массив с отсортированным по автору каталогом
}

sub search_author_sort_data_writing {
    my ( $author ) = @_;  # получить переданные аргументы
    my @catalog = search_author( $author ); # получить отсортированный по автору каталог
    
    @catalog = sort { # отсортировать каталог по дате написания в порядке возрастания
                     $a->{ "Creation" }->{ "Date of writing" }<=>
                     $b->{ "Creation" }->{ "Date of writing" }
                    } @catalog;
    
    return @catalog; # вернуть отсортированный массив
}

sub read_user_repository {
    my ( $user ) = @_; # получить переданные аргументы
    my @catalog; # массив для хранения возвращаемого каталога

    open FILEWORK, "<", "$user.json" # открыть хранилище пользователя
         or die "Can't open $user.json: $!";
    
    if ( -s "$user.json" ) { # если хранилище пользователя не пустое
          my $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> ); # получить декодированные данные из файла
          close FILEWORK; # закрыть файл
          
          return @$json_data_decode; # вернуть массив с хранилищем
    }
    else { # если хранилище пользователя пустое
          close FILEWORK; # закрыть файл

          return "User repository is empty."; # вернуть сообщение
    }
}

sub write_user_repository {
    my ( $user, $isbn ) = @_; # получить переданные аргументы
    my @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog; # определить размер каталога
    
    # Объявить переменные для хранения
    my @user_catalog; # заказов из хранилища пользователя
    my $size_user_catalog; # размера каталога с заказами пользователя
    my $json_data_encode; # закодированных данных в формат JSON
    my $ref_catalog; # ссылки на каталог для записи в хранилище
    my $i; # для использования цикла

    for ( $i = 0; $i < $size_catalog; $i++ ) {  # проверить наличие нового заказа в каталоге
          if ( $catalog[$i]->{ "ISBN" } eq $isbn ) { # если новый заказ есть в каталоге
               $catalog[$i]->{ "new_order" } = "yes"; # добавить ключ new_order с значением yes для нового заказа
          }
          else # если новый заказ отсутствует в каталоге
          {
               delete $catalog[$i]; # удалить из массива остальные элементы с позициями каталога
          }
    }

    @catalog = grep { defined $_ } @catalog; # удалить пустые элементы из массива с заказом

    if ( @catalog == 0 ) { return "nop"; } # если массив с заказом пустой вернуть сообщение nop
    
    @user_catalog = read_user_repository( $user ); # прочитать хранилище пользователя
    $size_user_catalog = scalar @user_catalog; # определить размер хранилища

    for ( $i = 0; $i < $size_user_catalog; $i++ ) { # проверить наличие нового заказа в хранилище пользователя
          if ( $user_catalog[0] ne "User repository is empty." && $user_catalog[$i]->{ "ISBN" } eq $isbn ) { # если новый заказ уже есть в хранилище
               return "yep"; # вернуть сообщение yep
          }
          elsif ( $user_catalog[0] ne "User repository is empty." ) { # если нового заказа нет в хранилище и хранилище не пустое
                  push @user_catalog, @catalog; # объединить массивы с хранилищем и заказом для записи
                  $ref_catalog = \@user_catalog; # создать ссылку на конечный массив
               }
               else { # если хранилище пустое
                  $ref_catalog = \@catalog; # создать ссылку только на новый заказ
               }

               $json_data_encode = JSON::XS->new->utf8->encode( $ref_catalog ); # получить закодированные данные в формате JSON

               open FILEWORK, ">", "$user.json" # открыть хранилище пользователя для записи
                    or die "Can't open $user.json: $!";
               
               print FILEWORK $json_data_encode; # записать закодированные данные в хранилище
               close FILEWORK; # закрыть хранилище
                    
               return "yep"; # вернуть сообщение yep
    }
}

# Вернуть 1
1;