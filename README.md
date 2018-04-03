# medline_trial

Simple web application that shows information from DB.

For proper work Postgresql DB running on localhost:5432 is required.
DB structure:
  1) DB name = "goods"
  
  2) tables:
    
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
