# Модуль бекенд для Perl Web-Server
package backend; # задать имя модуля

# Подключить модули для
use Modern::Perl; # ужесточения автоматического контроля 
use Exporter; # управления внешним интерфейсом модуля backend
use JSON::XS; # работы с файлами формата JSON

# Объявить переменные для
my @ISA = "Exporter"; # наследования методов
my @EXPORT = "process_request"; # создания синонима при импорте модуля
our @catalog; # хранения возвращаемого каталога

# Обработать URL и вызвать функцию для обработки каталога 
# или персонального хранилища пользователя
sub process_request {
    my ( $url ) = @_; # получить переданные аргументы
    $/ = undef; # присвоить значение undef для получения всех строк из файла

    if ( $url =~ /\/(\w+)\/?(\w+)?\/?(\w+)?\/?(.+)?/ ) { # парсить переданный URL
         if ( defined $1 ) { # если $1 инициализирована
              if ( defined $2 ) { # если $2 инициализирована
                   if ( $1 eq "orders" && not defined $3 ) { # если запрошено хранилище пользователя
                        return read_user_repository( $2 ); # вызвать функцию для чтения хранилища
                   }
                   if ( defined $3 ) { # если $3 инициализирована
                        if ( defined $4 && $1 eq "orders" && $3 eq "new" ) { # если запрошено добавление заказа в хранилище
                             return write_user_repository( $2, $4 ); # вызвать функцию для записи в хранилище
                        }
                        if ( $1 eq "catalog" && $3 eq "date_asc" ) { # если запрошена сортировка каталога по автору и дате
                             return search_author_sort_data_writing( $2 ); # вызвать функцию для сортировки каталога
                        }
                   }
                   else { # если $3 не инициализирована
                        if ( $1 eq "catalog" ) { # если запрошен каталог
                             return search_author( $2 ); # вызвать функцию для сортировки каталога по автору
                        }
                   }
              }
              else { # если инициализирована только $1
                   if ( $1 eq "catalog" ) { # если запрошен весь каталог
                        return read_catalog( ); # вызвать функцию для чтения каталога
                   }
              }
         }
    }
} 

# Прочитать каталог и вернуть массив с каталогом
sub read_catalog {
    open FILEWORK, "<", "catalog.json" # открыть файл catalog.json
         or die "Can't open catalog.json: $!";
    
    my $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> ); # получить декодированные данные из файла
    close FILEWORK; # закрыть файл
    
    my $size_catalog = @$json_data_decode; # определить размер каталога
    
    for ( my $i = 0; $i < $size_catalog; $i++ ) { # записать каталог в массив
          $catalog[$i] = $json_data_decode->[$i];
    }
    
    return @catalog; # вернуть массив с каталогом
}

# Прочитать каталог и вернуть массив с 
# отсортированным по автору каталогом
sub search_author {
    my ( $author ) = @_; # получить переданные аргументы
    @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog; # определить размер каталога
    $author =~ s/%20/ /; # заменить %20 на пробел
    
    for ( my $i = 0; $i < $size_catalog; $i++ ) { # найти в каталоге запрошенного автора
          unless ( $catalog[$i]->{ "Author" } =~ /$author/i ) { # если автор отсутствует
                   delete $catalog[$i]; # удалить из массива хеш без автора
          }
    }

    return @catalog; # вернуть массив с отсортированным по автору каталогом
}

# Прочитать каталог и вернуть массив с отсортированным 
# по автору и дате написания книги каталогом
sub search_author_sort_data_writing {
    my ( $author ) = @_;  # получить переданные аргументы
    @catalog = search_author( $author ); # получить отсортированный по автору каталог
    
    @catalog = sort { # отсортировать каталог по дате написания в порядке возрастания
                     $a->{ "Creation" }->{ "Date of writing" }<=>
                     $b->{ "Creation" }->{ "Date of writing" }
                    } @catalog;
    
    return @catalog; # вернуть отсортированный массив
}

# Прочитать персональное хранилище пользователя 
# и вернуть массив с хранилищем
sub read_user_repository {
    my ( $user ) = @_; # получить переданные аргументы
    
    open FILEWORK, "<", "$user.json" # открыть хранилище пользователя
         or die "Can't open $user.json: $!";
    
    if ( -s "$user.json" ) { # если хранилище пользователя не пустое
          my $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> ); # получить декодированные данные из файла
          close FILEWORK; # закрыть файл
          
          my $size_catalog = @$json_data_decode; # определить размер хранилища

          for ( my $i = 0; $i < $size_catalog; $i++ ) { # записать хранилище в массив
                $catalog[$i] = $json_data_decode->[$i];
          }
          
          return @catalog; # вернуть массив с хранилищем
    }
    else { # если хранилище пользователя пустое
          close FILEWORK; # закрыть файл

          return $catalog[0] = "User repository is empty."; # вернуть массив с сообщением
    }
}

# Записать в персональное хранилище пользователя новый заказ
sub write_user_repository {
    my ( $user, $isbn ) = @_; # получить переданные аргументы
    @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog; # определить размер каталога
    
    # Объявить переменные для хранения
    my @new_catalog; # нового заказа
    my @user_catalog; # заказов из хранилища пользователя
    my $size_user_catalog; # размера каталога с заказами пользователя
    my @write_catalog; # каталога для записи в хранилище пользователя
    my $json_data_decode; # декодированных данных из формата JSON
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

    if ( @catalog == 0 ) { return $catalog[0] = "nop"; } # если массив с заказом пустой вернуть сообщение nop
    
    @new_catalog = @catalog; # сохранить новый заказ в массиве
    @user_catalog = read_user_repository( $user ); # прочитать хранилище пользователя
    $size_user_catalog = scalar @user_catalog; # определить размер хранилища

    for ( $i = 0; $i < $size_user_catalog; $i++ ) { # проверить наличие нового заказа в хранилище пользователя
          if ( $user_catalog[$i]->{ "ISBN" } eq $isbn ) { # если новый заказ уже есть в хранилище
               @catalog = ( ); # обнулить массив
               return $catalog[0] = "yep"; # вернуть сообщение yep
          }
          else { # если нового заказа нет в хранилище
               if ( $catalog[0] ne "User repository is empty." ) { # если элемент массива хранилища не содержит сообщение
                    @write_catalog = ( @user_catalog, @new_catalog ); # объединить массивы с хранилищем и заказом для записи
               }
               else { # если элемент массива с хранилищем содержит сообщение
                    @write_catalog = @new_catalog; # записать массив с новым заказом в массив для записи
               }
               $ref_catalog = \@write_catalog; # создать ссылку на массив для записи
               $json_data_encode = JSON::XS->new->utf8->encode( $ref_catalog ); # получить закодированные данные в формате JSON

               open FILEWORK, ">", "$user.json" # открыть хранилище пользователя для записи
                    or die "Can't open $user.json: $!";
               
               print FILEWORK $json_data_encode; # записать закодированные данные в хранилище
               close FILEWORK; # закрыть хранилище
                    
               @catalog = ( ); # обнулить массив
               return $catalog[0] = "yep"; # вернуть сообщение yep
          }
    }
}

# Вернуть 1
1;