Описание модуля соединения с БД
Назначение
1. соединение с БД
2. чтение данных из БД
3. запись данных в БД.

Структура
1. стандартный набор модуля в Perl
2. функция для чтения данных из БД
3. функция для записи данных в БД.

Реализация
1. подключение модуля DBI и соединение с сервером БД по IP-адресу и порту
2. функции для чтения и записи должны принимать аргументы
  1. для чтения в качестве аргументов принимать имя игрока
  2. для записи в качестве аргументов принимать имя игрока и столбцы.


Описание сущности локация
1-с Сущность: Локация. Атрибуты и методы содержатся в package Location

2-с Атрибуты/Свойства сущности Локация

Доступные атрибуты:
$location->{ name } - имя объекта
$location->{ diameter } - диаметр объекта
$location->{ coordinates } - координаты объекта
$location->{ move_enable } - возможность перемещения
$location->{ move_speed } - скорость перемещения

Приватные атрибуты
....

3-с Методы сущности Локация
Cоздать новый объект:
-на входе: название объекта, диаметр, координаты, возможность перемещения, скорость перемещения
-на выходе: получить объект локации.
$location->new( $name => 'Earth', $diameter => '12742', $coordinates => '10', $move_enable => 'no', $move_speed => '0' );

Переместить объект:
-на входе: возможность перемещения, скорость перемещения, координаты перемещения
-на выходе: переместить объект.
$location->move( $move_enable, $move_speed, $move_coordinates );

Уничтожить объект:
-на входе: ссылка на объект?
-на выходе: уничтожить объект.
$location->DESTROY( .... );

4-с Описание таблиц сущности Локация