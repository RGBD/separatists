select u1.*, u2.* from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id order by u1.id, u2.id;

select u1.*, u2.*, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) distance
from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
order by u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) desc;

select u1.*, u2.*, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) distance
from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
order by u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) desc;

select nationality, distance from (
  select d1.nationality, max(sqrt(power(d1.lat - d2.lat, 2) + power(d1.lon - d2.lon, 2))) distance
  from users d1 join users d2 on d1.nationality = d2.nationality and d1.id < d2.id
  group by d1.nationality
  order by d1.nationality) dq;

/* select max in each country */
select u1.*, u2.*, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lat - u2.lat, 2)) distance
from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
  join (
    select d1.nationality, max(sqrt(power(d1.lat - d2.lat, 2) + power(d1.lon - d2.lon, 2))) distance
    from users d1 join users d2 on d1.nationality = d2.nationality and d1.id < d2.id
    group by d1.nationality
    order by d1.nationality
  ) dq
    on dq.nationality = u1.nationality and sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) >= dq.distance
order by u1.nationality;

select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
  from (
  select u1.id, u1.name, u2.id, u2.name, u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) distance
  from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
  order by u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) desc
) dq;

select rank_filter.* from (
  select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
    from (
    select u1.id, u1.name, u2.id, u2.name, u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) distance
    from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
    order by u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) desc
  ) dq
) rank_filter where rank <= 3 order by nationality;

select rq.nationality, rq.user_id_1, rq.user_id_2, rq.distance from (
  select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
    from (
    select u1.nationality, u1.id as user_id_1, u2.id as user_id_2,
    earth_distance(ll_to_earth(u1.lat, u1.lon), ll_to_earth(u2.lat, u2.lon)) distance
    from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
  ) dq
) rq where rank <= 3 order by nationality;

select rq.nationality, rq.user_id_1, rq.user_id_2, rq.distance from (
  select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
    from (
      select u1.nationality, u1.id as user_id_1, u2.id as user_id_2,
      earth_distance(u1.e, u2.e) distance
      from (select id, nationality, ll_to_earth(lat, lon) e from users order by nationality, id) u1
      join (select id, nationality, ll_to_earth(lat, lon) e from users order by nationality, id) u2
      on u1.nationality = u2.nationality and u1.id < u2.id
    ) dq
) rq where rank <= 3 order by nationality;

with uu as (
  select id, nationality, ll_to_earth(lat, lon) e from users order by nationality, id
)
  select rq.nationality, rq.user_id_1, rq.user_id_2, rq.distance from (
    select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
      from (
        select u1.nationality, u1.id as user_id_1, u2.id as user_id_2,
        earth_distance(u1.e, u2.e) distance
        from uu u1
        join uu u2
        on u1.nationality = u2.nationality and u1.id < u2.id
      ) dq
  ) rq where rank <= 3 order by nationality;
