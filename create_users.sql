create extension cube;
create extension earthdistance;

drop table if exists users;
create table users(
  id serial primary key,
  name varchar,
  nationality varchar(3),
  lat float(8),
  lon float(8)
);

create index index_users_on_nationality on users (nationality);
