# K8s Sample API 

This is a fast api application that will allow for user signups and logins.  

It does really nothing else. 

## Database migrations

To make a database migration (if you add a model)

Run: 

```
docker-compose up # make sure the database is running
alembic revision --autogenerate -m 'initial revision'
```