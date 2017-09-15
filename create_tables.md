CREATE TABLE game_area(id int(8) NOT NULL AUTO_INCREMENT, number int(2) NOT NULL DEFAULT '0', size_x int(3) NOT NULL DEFAULT '0', size_y int(3) NOT NULL DEFAULT '0', PRIMARY KEY(id));

CREATE TABLE location_object(id int(8) NOT NULL AUTO_INCREMENT, name varchar(15) NOT NULL DEFAULT 'NULL', coordinate_x int(3) NOT NULL DEFAULT '0', coordinate_y int(3) NOT NULL DEFAULT '0', area_number int(2) NOT NULL DEFAULT '0', PRIMARY KEY(id));
