create_users.sql - schema initialize schema
gen.rb - generate sql for seed
solution.sql - the solution

```
psql < create_users.sql
gen.rb | psql
psql < solution.sql
```

a bit faster solution in solution_lateral.sql

solution can be optimized further by:
- storing earth type coordinates directly as column, instead of lat, lon,
- using postgis, building convex hull for each group,
  then finding max distance in much smaller set of rows
