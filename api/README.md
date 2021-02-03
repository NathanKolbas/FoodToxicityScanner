# Rails
This is like any other Rails application but with one slight change; it is running as an API.

* Ruby version  
2.6.6

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Database
The database is a Postgress database. There is seed data that can be used to populate the database for testing.

## Sign-in
Sign-in uses token based authentication. A user token is generated whening signing in with the `jwt` gem. The timeout is currently set to tweent-four hours. This has room for improvment.

## Security
User passwords are encrypted in the database. In the future the passwords should also be salted for added security. The API also has a `master.key` (stored in the /config directory) which is used for encryption and decryption. I do not know if another key can be generated and used. This key is not committed for security reasons.

## Testing
Testing, again, **NEEDS** to be implemented as it was not a priority in the time I had.
