# Модуль бекенд для Perl Web-Server
package backend; # задать имя модуля

use Modern::Perl;
use Exporter; # подключить модуль, управляющий внешним интерфейсом модуля
use JSON::XS; # подключить модуль для работы с файлами .json

my @ISA = "Exporter"; # инициализировать специальный массив для наследования методов
my @EXPORT = "process_request"; # инициализировать специальный массив для создания синонима при импорте модуля
my $json_data_decode; # объявить переменную для хранения декодированных данных из файла формата json
my @parse_url;
my $size_parse_url;
our @catalog;
my $size_catalog;
my $i;
my @new_catalog;
my @user_catalog;
my $size_user_catalog;
my @write_catalog;
my $ref_catalog;
my $json_data_encode;

my $parse_url;

# Обработать URL и вызвать соответствующую
# функцию для обработки каталога или
# персонального хранилища пользователя
sub process_request {
    my ( $url ) = @_; # получить переданные аргументы

    $/ = undef; # присвоить переменной $/ значение undef для получения всех строк из файла

    # Разделить URL на ключевые слова разделителем /
    # и записать слова в массив
    #@parse_url = split /\//, $_[0];

    if ( $url =~ /\/(.*)\/(.*)/ ) {
         if ( $1 eq "catalog" ) {
              read_catalog();
              if ( $2 ne "" ) {
                   #search_author();
              }
         }
    }
    
    # Определить размер массива ключевых слов
    #$size_parse_url = @parse_url;

    # В зависимости от размера массива ключевых
    # слов вызвать функцию для обработки каталога
    # или персонального хранилища пользователя
    #if ( $size_parse_url == 2 && $parse_url[1] eq "catalog" ) {
         # Если получен URL из двух ключевых слов и
         # вторым из них является слово catalog
         # вызвать функцию для возврата всего каталога
         #read_catalog();
    #}

    # Если получен URL из трех ключевых слов
    #if ( $size_parse_url == 3 ) {
         # Если вторым ключевым словом является orders
         #if ( $parse_url[1] eq "orders" ) {
              # Вызвать функцию для возврата персонального
              # хранилища пользователя
              #return read_user_catalog();
         #}
         #else {
              # Если вторым ключевым словом является catalog
              #if ( $parse_url[1] eq "catalog" ) {
                   # Вызвать функцию для возврата
                   # отсортированного по автору каталога
                   #return search_author();
              #}
         #}
    #}

    # Если получен URL из четырех ключевых слов
    # и вторым является слово catalog, а четвертым 
    # слово date_asc
    #if ( $size_parse_url == 4 && $parse_url[1] eq "catalog" && $parse_url[3] eq "date_asc" ) {
         # Вызвать функцию для возврата отсортированного 
         # по автору и дате написания книги каталога 
         #return search_author_sort_data_writing();
    #}

    # Если получен URL из пяти ключевых слов
    # и вторым является слово orders, а четвертым 
    # слово new
    #if ( $size_parse_url == 5 && $parse_url[1] eq "orders" && $parse_url[3] eq "new" ) {
         # Вызвать функцию для записи нового заказа
         # в персональное хранилище пользователя 
         #return write_user_catalog();
    #}
} 

# Прочитать каталог и вернуть массив с каталогом
sub read_catalog {
    # Открыть файловый дескриптор для файла catalog.json
    open FILEWORK, "<", "catalog.json"
         or die "Can't open catalog.json: $!";

    # Объявить переменную для хранения декодированных 
    # данных из файла catalog.json
    $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> );

    # Закрыть файловый дескриптор
    close FILEWORK;

    # Определить размер каталога
    $size_catalog = @$json_data_decode;

    # Записать каталог в массив
    for ( $i = 0; $i < $size_catalog; $i++ ) {
          $catalog[$i] = $json_data_decode->[$i];
    }
    # Вернуть массив с каталогом
    return @catalog;
}

# Прочитать персональное хранилище 
# пользователя и вернуть массив с хранилищем
sub read_user_catalog {
    # Открыть файловый дескриптор для файла 
    # имя_пользователя.json
    open FILEWORK, "<", "$parse_url[2].json"
         or die "Can't open $parse_url[2].json: $!";
    
    # Если хранилище пользователя не пустое
    if ( -s "$parse_url[2].json" ) {
          # Объявить переменную для хранения
          # декодированных данных из файла
          $json_data_decode = JSON::XS->new->utf8->decode( <FILEWORK> );

          # Закрыть файловый дескриптор
          close FILEWORK;

          # Определить размер хранилища
          $size_catalog = @$json_data_decode;

          # Записать хранилище в массив
          for ( my $i = 0; $i < $size_catalog; $i++ ) {
                $catalog[$i] = $json_data_decode->[$i];
          }
          # Вернуть массив с хранилищем
          return @catalog;
    }
    # Если хранилище пользователя пустое
    else {
          # Вернуть массив с сообщением
          return $catalog[0] = "User repository is empty.";
    }
}

# Прочитать каталог и вернуть массив с 
# отсортированным по автору каталогом
sub search_author {
    # Вызвать функцию для возврата всего каталога
    return read_catalog();

    # Заменить в третьем ключевом слове 
    # %20 на пробел для поиска в каталоге
    $parse_url[2] =~ s/%20/ /;

    # Перебрать элементы массива с каталогом
    for ( $i = 0; $i < $size_catalog; $i++ ) {
          # Если в хеше отсутстует ключ с нужным автором
          unless ( $catalog[$i]->{ "Author" } =~ /$parse_url[2]/i ) {
                   # Удалить из массива с каталогом данный хеш
                   delete $catalog[$i];
          }
    }
    # Вернуть массив с отсортированным по 
    # автору каталогом
    return @catalog;
}

# Прочитать каталог и вернуть массив с 
# отсортированным по автору и дате написания
# книги каталогом
sub search_author_sort_data_writing {
    # Вызвать функцию для возврата отсортированного
    # по автору каталога
    return search_author();
    
    # Отсортировать каталог по дате написания
    # в порядке возрастания
    @catalog = sort { 
                     $a->{ "Creation" }->{ "Date of writing" }<=>
                     $b->{ "Creation" }->{ "Date of writing" }
                    } @catalog;
    # Вернуть массив с отсортированным по 
    # автору и дате написания книги каталогом
    return @catalog;
}

# Записать в персональное хранилище пользователя
# новый заказ
sub write_user_catalog {
    # Вызвать функцию для возврата всего каталога
    return read_catalog();

    # Проверить наличие нового заказа пользователя
    # в каталоге
    for ( $i = 0; $i < $size_catalog; $i++ ) {
          # Если новый заказ есть в каталоге
          if ( $json_data_decode->[$i]->{ "ISBN" } eq $parse_url[4] ) {
               # Сформировать массив с новым заказом
               $catalog[$i] = $json_data_decode->[$i];
               
               # Добавить ключ new_order и значение yes
               # для нового заказа
               $catalog[$i]->{ "new_order" } = "yes";
          }
          # Если новый заказ отсутствует в каталоге
          else
          {
               # Удалить из массива остальные элементы
               # с позициями каталога
               delete $catalog[$i];
          }
    }
    # Удалить пустые элементы из массива с заказом
    @catalog = grep { defined $_ } @catalog;

    # Если массив с заказом пустой
    if ( @catalog == 0 ) {
         # Вернуть сообщение nop
         return $catalog[0] = "nop";
    }
    # Иначе проверить наличие нового заказа
    # в хранилище пользователя и выполнить запись
    else {
         # Сохранить новый заказ в массиве
         @new_catalog = @catalog;

         # Прочитать хранилище пользователя
         return read_user_catalog();

         # Записать размер хранилища ользователя 
         # в массив
         @user_catalog = @catalog;
         
         # Определить размер хранилища
         $size_user_catalog = @user_catalog;

         # Проверить наличие нового заказа
         # в хранилище пользователя
         for ( $i = 0; $i < $size_user_catalog; $i++ ) {
               # Если новый заказ уже есть в хранилище
               if ( $user_catalog[$i]->{ "ISBN" } eq $parse_url[4] ) {
                    # Обнулить массив
                    @catalog = ();
                    
                    # Вернуть сообщение yep
                    return $catalog[0] = "yep";
               }
               # Если нового заказа нет в хранилище
               else {
                    # Если значение первого элемента массива
                    # хранилища не содержит сообщение
                    if ( $catalog[0] ne "User repository is empty." ) {
                         # Объединить массивы с имеющимся заказом
                         # и новым заказом в массив для записи
                         @write_catalog = ( @user_catalog, @new_catalog );
                    }
                    # Если значение первого элемента массива
                    # с хранилищем содержит сообщение
                    else {
                         # Записать массив с новым заказом
                         # в массив для записи
                         @write_catalog = @new_catalog;
                    }
                    # Создать ссылку на массив для записи
                    $ref_catalog = \@write_catalog;
    
                    # Объявить переменную для хранения
                    # закодированных данных в формат JSON
                    $json_data_encode = JSON::XS->new->utf8->encode( $ref_catalog );

                    # Открыть файловый дескриптор для
                    # записи в хранилище пользователя
                    open FILEWORK, ">", "$parse_url[2].json"
                         or die "Can't open $parse_url[2].json: $!";

                    # Записать закодированные данные
                    # в хранилище пользователя
                    print FILEWORK $json_data_encode;

                    # Закрыть файловый дескриптор
                    close FILEWORK;
                    
                    # Обнулить массив
                    @catalog = ();
                    
                    # Вернуть сообщение yep
                    return $catalog[0] = "yep";
               }
         }
    }
}

# Вернуть 1
1;