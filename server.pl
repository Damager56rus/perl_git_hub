#!/usr/bin/perl
# Perl Web-Server

# Подключить модули для
use Modern::Perl; # ужесточения автоматического контроля
use Socket; # использования сокета
use BackendDb; # использования модуля бекенда

# Объявить переменные для хранения
my @arguments = @ARGV; # аргументов из командной строки
my $ip_address = $arguments[1]; # IP-адреса сервера
my $port = $arguments[3]; # порта сервера
my $data; # запросов и ответов

socket( SERVER, PF_INET, SOCK_STREAM, getprotobyname( 'tcp' ) ) # cоздать сокет с параметрами ИМЯ, ДОМЕН, ТИП, ПРОТОКОЛ
       or die "Can't open socket $!\n";

bind( SERVER, pack_sockaddr_in( $port, inet_aton( $ip_address ) ) ) # привязать сокет к порту и IP-адресу хоста
    or die "Can't bind to port $port! \n";

listen( SERVER, 5 ) or die "listen: $!"; # вызвать прослушивание входящих запросов на порту

say "SERVER started on port $port"; # сообщение о запуске сервера с указанием порта

while ( accept( CLIENT, SERVER ) ) { # принимать входящие соединения
       chomp ( $data = <CLIENT> ); # получить запрос от клиента
       
       say "Получен запрос: $data"; # сообщение о получении запроса

       if ( $data =~ /(\/.*) H/ && $1 ne "favicon.ico" ) { # если не запрошен favicon.ico выделить URI из запроса
            my @catalog = BackendDb::process_request( $1 ); # передать URL в метод process_request бекенда
            responce_data( @catalog ); # сформировать и отправить ответ клиенту
       }
      
       close CLIENT; # закрыть сокет клиента после отправки ответа
}

sub responce_data {
    my ( @catalog ) = @_; # получить переданные аргументы
    if ( $catalog[0] eq "" ) { # если от бекенда получен пустой массив
         responce_404_error(); # отправить ответ с кодом состояния 404 Not Found
    }
    else { # если от бекенда получен не пустой массив
         responce_200_ok(); # отправить ответ с кодом состояния 200 Ok

         foreach my $array1( @catalog ) { # отправить полученное от бекенда содержимое
                 if ( $array1 ne "User repository is empty." && $array1 ne "yep" && $array1 ne "nop" ) { # если не получено одно из сообщений
                      my $rupture_counter = 0; # счетчик для отправки разрыва между позициями каталога
                      my $rupture_comparator = 5; # переменная для хранения частоты разрыва

                      if ( $array1->{ "new_order" } ) { $rupture_comparator = 6; } # если есть ключ new_order увеличить частоту разрыва

                      while ( ( my $key, my $value ) = each %$array1 ) { # перебрать все ключи и значения из хешей
                                $rupture_counter++; # увеличить счетчика разрыва на 1

                                if ( $key eq "Creation" ) { # если ключ имеет имя Creation
                                     my $hash1 = $array1->{ "Creation" }; # записать хеш по ключу Creation
                                
                                     print CLIENT "<html><center><h1>Creation: </center></h1></html>"; # отправить содержимое Creation:
                               
                                     while ( ( my $key1, my $value1 ) = each %$hash1 ) { # перебрать все ключи и значения хеша Creation
                                               print CLIENT "<html><center><h1>$key1: $value1</center></h1></html>";  # отправить ключи: значения хеша Creation
                                     }
                                }
                                else { # если ключ не имеет имя Creation
                                     print CLIENT "<html><center><h1>$key: $value</center></h1></html>"; # отправить содержимое остальных хешей
                                }
                                
                                if ( $rupture_counter == $rupture_comparator ) { # если счетчик разрывов равен частоте разрывов
                                     print CLIENT "<html><center><h1>---</center></h1></html>";  # отправить разрыв между позициями каталога
                                }
                      }
                 }
                 else { # если получено одно из сообщений
                      print CLIENT "<html><center><h1>$array1</center></h1></html>"; # отправить содержимое с сообщением
                 }
         }
    }
}

sub responce_200_ok {
    print CLIENT 
<< "EOF";
    HTTP/1.1 200 OK
    Server: My_Perl_Server
    Content-Type: text/html
    Connection: Closed

EOF
}

sub responce_404_error {
    print CLIENT 
<< "EOF";
    HTTP/1.1 404 Not Found
    Server: My_Perl_Server
    Content-Type: text/html
    Connection: Closed

EOF
}
