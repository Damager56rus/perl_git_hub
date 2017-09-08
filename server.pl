#!/usr/bin/perl
# Perl Web-Server

use Modern::Perl;

# Подключить модуль для использования сокета
use Socket;

use backend;

# Объявить массив и инициализировать его 
# элементы аргументами из командной строки
my @arguments = @ARGV;

# Объявить и инициализировать переменные 
# для хранения IP-адреса и порта сервера
my $ip_address = $arguments[1];
my $port = $arguments[3];
#my $backend_number = $arguments[5];

# Объявить переменную для хранения запросов и ответов
my $data;

# Создать сокет с параметрами ИМЯ, ДОМЕН, ТИП, ПРОТОКОЛ
socket( SERVER, PF_INET, SOCK_STREAM, getprotobyname( 'tcp' ) )
       or die "Can't open socket $!\n";

# Привязать сокет к порту и IP-адресу хоста
bind( SERVER, pack_sockaddr_in( $port, inet_aton( $ip_address ) ) )
    or die "Can't bind to port $port! \n";

# Вызвать прослушивание входящих запросов
# на указанном порту
listen( SERVER, 5 ) or die "listen: $!";

# Вывести сообщение о запуске сервера
# с указанием порта
say "SERVER started on port $port";

# Вызвать функцию для приема входящих соединений
while ( accept( CLIENT, SERVER ) ) { 
       # Получить запрос от клиента и обрезать
       # символ новой строки
       chomp ( $data = <CLIENT> );
       
       # Вывести сообщение о получении
       # запроса и текст запроса
       say "Получен запрос: $data";

       # Обработать запрос от клиента, выделив URI
       # и передать URL в метод process_request
       # если не запрошен favicon.ico
       if ( $data =~ /(\/.*) H/ && $1 ne "favicon.ico" ) { 
            backend::process_request( $1 );

            # Сформировать ответ из полученного от
            # бекенда каталога и отправить его клиенту
            responce_data();
       }
       # Закрыть сокет клиента после отправки ответа
       close CLIENT;
}

# Сформировать и отправить ответ от сервера
sub responce_data {
    # Если от бекенда получен пустой массив
    if ( @backend::catalog == 0 ) {
    #if ( $backend_db::catalog == 0 ) {
         # Вызвать функцию для отправки ответа
         # с кодом состояния 404 Not Found
         responce_404_error();
    }
    # Если от бекенда получен не пустой массив
    else {
         # Вызвать функцию для отправки ответа
         # с кодом состояния 200 Ok
         responce_200_ok();
    
         # Отправить полученное от бекенда
         # содержимое массива
           foreach my $array1( @backend::catalog ) {
          #foreach my $array1( $backend_db::catalog ) {
                 # Если значение первого элемента массива 
                 # не равно тексту одного из сообщений
                 if ( $array1 ne "User repository is empty." && $array1 ne "yep" && $array1 ne "nop" ) {
                      # Объявить и инициализировать счетчик для 
                      # отправки разрыва между позициями каталога
                      my $rupture_counter = 0;
                      
                      # Объявить и инициализировать переменную
                      # для определения частоты разрыва
                      my $rupture_comparator = 3;

                      # Если в массиве у хеша есть ключ new_order
                      # увеличить частоту разрыва
                      if ( $array1->{ "new_order" } ) { $rupture_comparator = 4; }

                      # Перебрать все ключи и значения из хешей,
                      # являющихся элементами массива
                      while ( ( my $key, my $value ) = each %$array1 ) {
                                # Увеличить значение счетчика разрывов на 1
                                $rupture_counter++;

                                # Если ключ имеет имя Creation
                                if ( $key eq "Creation" ) {
                                     # Объявить и инициализировать хеш элементами
                                     # хеша по ключу Creation
                                     my $hash1 = $array1->{ "Creation" };
                                
                                     # Отправить содержимое Creation:
                                     print CLIENT "<html><center><h1>Creation: </center></h1></html>";
                               
                                     # Перебрать все ключи и значения хеша,
                                     # полученного по ключу Creation
                                     while ( ( my $key1, my $value1 ) = each %$hash1 ) {
                                              # Отправить содержимое с ключами: значениями
                                              # хеша, полученного по ключу Creation
                                              print CLIENT "<html><center><h1>$key1: $value1</center></h1></html>";
                                     }
                                }
                                # Если ключ не имеет имя Creation
                                else {
                                     # Отправить содержимое с ключами: значениями
                                     # из остальных хешей
                                     print CLIENT "<html><center><h1>$key: $value</center></h1></html>";
                                }
                                # Если счетчик разрывов равен частоте разрывов
                                if ( $rupture_counter == $rupture_comparator ) { 
                                     # Отправить содержимое --- 
                                     # между позициями каталога
                                     print CLIENT "<html><center><h1>---</center></h1></html>"; 
                                }
                      }
                 }
                 # Если значение первого элемента массива 
                 # равно тексту одного из сообщений
                 else {
                      # Отправить содержимое с сообщением
                      print CLIENT "<html><center><h1>$array1</center></h1></html>";
                 }
         }
    }
}

# Отправить строку состояния с кодом 200 ОК
# и поля заголовка ответа от сервера
sub responce_200_ok {
    print CLIENT 
<< "EOF";
    HTTP/1.1 200 OK
    Server: My_Perl_Server
    Content-Type: text/html
    Connection: Closed

EOF
}

# Отправить строку состояния с кодом 404 Not Found
# и поля заголовка ответа от сервера
sub responce_404_error {
    print CLIENT 
<< "EOF";
    HTTP/1.1 404 Not Found
    Server: My_Perl_Server
    Content-Type: text/html
    Connection: Closed

EOF
}