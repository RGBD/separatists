create_users.sql - schema initialize schema
gen.rb - generate sql for seed
solution.sql - the solution

```
psql < create_users.sql
gen.rb | psql
psql < solution.sql
```
