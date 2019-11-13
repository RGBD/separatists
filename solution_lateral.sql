with uu as (
  select id, nationality, ll_to_earth(lat, lon) e from users order by nationality, id
)
select nationality, user_id_1, user_id_2, distance
from (
  select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
  from (
    select
      u1.nationality, u1.id as user_id_1, u2.id as user_id_2,
      earth_distance(u1.e, u2.e) distance
    from uu u1
    cross join lateral (
      select *
      from uu u2 where u1.nationality = u2.nationality and u1.id < u2.id
      order by earth_distance(u1.e, u2.e) desc
      limit 3
    ) u2
  ) dq
) rq where rank <= 3;
