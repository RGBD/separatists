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
