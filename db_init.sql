create database goods;

\c goods;

create table parts(
	  id integer primary key
	, name varchar(127)
	, number varchar(127)
	, vendor varchar(127)
);

create table orders(
	  id integer primary key
	, part_id integer references parts(id)
	, qty integer
	, ship_dt date
	, receive_dt date
);



CREATE USER webapp WITH PASSWORD 'hello';

grant select
on parts
to webapp;

grant select
on parts
to webapp;



INSERT INTO parts 
VALUES 
    (1, 'QU Bell', '334F-13', 'BOYS LTD')
  , (2, 'FF Lockpad', '185Z-01', 'BOYS LTD')
  , (3, 'GP Doorknob', '702Z-31', 'GUYS INC')
;

INSERT INTO orders(id, part_id, qty, ship_dt, receive_dt) 
VALUES
      (1, 3, 50, '2017-05-03', '2017-05-20')
    , (2, 3, 20, '2017-05-03', '2017-05-20')
    , (3, 1, 100, '2017-10-15', '2017-10-18')
    , (4, 3, 5000, '2018-01-20', '2018-02-05')
    , (5, 2, 150, '2018-01-25', '2018-01-30')
    , (6, 2, 777, null, null)
    , (7, 1, 25, '2018-02-06', null)
;
