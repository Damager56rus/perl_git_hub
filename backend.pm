# Модуль бекенд для Perl Web-Server
package backend; # задать имя модуля
# Подключить модули
use Modern::Perl; # модуль для ужесточения автоматического контроля 
use Exporter; # модуль, управляющий внешним интерфейсом модуля backend
use JSON::XS; # модуль для работы с файлами .json
# Объявить переменные
my @ISA = "Exporter"; # массив для наследования методов
my @EXPORT = "process_request"; # массив для создания синонима при импорте модуля
our @catalog;

# Обработать URL и вызвать соответствующую
# функцию для обработки каталога или
# персонального хранилища пользователя
sub process_request {
    my ( $url ) = @_; # получить переданные функции аргументы
    $/ = undef; # присвоить значение undef для получения всех строк из файла
    # Разделить URL на ключевые слова разделителем /
    # и записать слова в массив
    #@parse_url = split /\//, $_[0];

    if ( $url =~ /\/(\w+)\/?(\w+)?\/?(\w+)?\/?(.+)?/ ) {
         if ( defined $1 ) {
              if ( defined $2 ) {
                   if ( $1 eq "orders" && $3 ne "new" ) {
                        return read_user_repository( $2 );
                   }
                   if ( defined $3 ) {
                        if ( defined $4 && $1 eq "orders" && $3 eq "new" ) {
                             return write_user_repository( $2, $4 );
                        }
                        if ( $3 eq "date_asc" ) {
                             return search_author_sort_data_writing( $2 ); 
                        }
                   }
                   else {
                        if ( $1 eq "catalog" ) {
                             return search_author( $2 );
                        }
                   }
              } 
              else {
                   if ( $1 eq "catalog" ) {
                        return read_catalog( );
                   }
              }
         }
    }
} 

# Прочитать каталог и вернуть массив с каталогом
sub read_catalog {
    open FILEWORK, "<", "catalog.json" # открыть файловый дескриптор для файла catalog.json
         or die "Can't open catalog.json: $!";
    my $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> ); # получить декодированные данные из файла
    close FILEWORK; # закрыть файловый дескриптор
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
    my $size_catalog = scalar @catalog;
    $author =~ s/%20/ /; # заменить %20 на пробел
    
    for ( my $i = 0; $i < $size_catalog; $i++ ) { # перебрать элементы массива с каталогом
          unless ( $catalog[$i]->{ "Author" } =~ /$author/i ) { # если в хеше отсутстует ключ с нужным автором
                   delete $catalog[$i]; # удалить из массива с каталогом данный хеш
          }
    }

    return @catalog; # вернуть массив с отсортированным по автору каталогом
}

# Прочитать каталог и вернуть массив с отсортированным 
# по автору и дате написания книги каталогом
sub search_author_sort_data_writing {
    my ( $author ) = @_;  # получить переданные аргументы
    our @catalog = search_author( $author ); # получить отсортированный по автору каталог
    
    @catalog = sort { # отсортировать каталог по дате написания в порядке возрастания
                     $a->{ "Creation" }->{ "Date of writing" }<=>
                     $b->{ "Creation" }->{ "Date of writing" }
                    } @catalog;
    
    return @catalog; # вернуть отсортированный массив
}

# Прочитать персональное хранилище пользователя 
# и вернуть массив с хранилищем
sub read_user_repository {
    my ( $user ) = @_;
    open FILEWORK, "<", "$user.json" # открыть файловый дескриптор для открытия файла
         or die "Can't open $user.json: $!";
    
    if ( -s "$user.json" ) { # если хранилище пользователя не пустое
          my $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> ); # получить декодированные данные из файла
          close FILEWORK; # закрыть файловый дескриптор
          my $size_catalog = @$json_data_decode; # определить размер хранилища

          for ( my $i = 0; $i < $size_catalog; $i++ ) { # записать хранилище в массив
                $catalog[$i] = $json_data_decode->[$i];
          }
          
          return @catalog; # вернуть массив с хранилищем
    }
    else { # если хранилище пользователя пустое
          close FILEWORK; # закрыть файловый дескриптор

          return $catalog[0] = "User repository is empty."; # вернуть массив с сообщением
    }
}

# Записать в персональное хранилище пользователя новый заказ
sub write_user_repository {
    my ( $user, $isbn ) = @_;
    @catalog = read_catalog( ); # получить весь каталог
    my $size_catalog = scalar @catalog;
    my @new_catalog;
    my @user_catalog;
    my $size_user_catalog;
    my @write_catalog;
    my $json_data_decode;
    my $json_data_encode;
    my $ref_catalog;
    my $i;

    for ( $i = 0; $i < $size_catalog; $i++ ) {  # проверить наличие нового заказа пользователя в каталоге
          if ( $catalog[$i]->{ "ISBN" } eq $isbn ) { # если новый заказ есть в каталоге
               $catalog[$i]->{ "new_order" } = "yes"; # добавить ключ new_order и значение yes для нового заказа
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
               if ( $catalog[0] ne "User repository is empty." ) { # если значение первого элемента массива хранилища не содержит сообщение
                    @write_catalog = ( @user_catalog, @new_catalog ); # объединить массивы с имеющимся заказом и новым заказом в массив для записи
               }
               else { # если значение первого элемента массива с хранилищем содержит сообщение
                    @write_catalog = @new_catalog; # записать массив с новым заказом в массив для записи
               }
               $ref_catalog = \@write_catalog; # создать ссылку на массив для записи
               $json_data_encode = JSON::XS->new->utf8->encode( $ref_catalog ); # получить закодированные данные в формат JSON

               open FILEWORK, ">", "$user.json" # открыть файловый дескриптор для записи в хранилище пользователя
                    or die "Can't open $user.json: $!";
               print FILEWORK $json_data_encode; # записать закодированные данные в хранилище пользователя
               close FILEWORK; # закрыть файловый дескриптор
                    
               @catalog = ( ); # обнулить массив
               return $catalog[0] = "yep"; # вернуть сообщение yep
          }
    }
}

# Вернуть 1
1;