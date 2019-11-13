select rq.nationality, rq.user_id_1, rq.user_id_2, rq.distance from (
  select dq.*, rank() over (partition by dq.nationality order by dq.distance desc)
    from (
    select u1.nationality, u1.id as user_id_1, u2.id as user_id_2,
    earth_distance(ll_to_earth(u1.lat, u1.lon), ll_to_earth(u2.lat, u2.lon))
    distance
    from users u1 join users u2 on u1.nationality = u2.nationality and u1.id < u2.id
    order by u1.nationality, sqrt(power(u1.lat - u2.lat, 2) + power(u1.lon - u2.lon, 2)) desc
  ) dq
) rq where rank <= 3 order by nationality;
