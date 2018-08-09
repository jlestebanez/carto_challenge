# INTRO
- Despite time, clients and work here is my propousal for code challenge, i wish it fulfill expectations
- Sinatra for and easy and scalable api/router framework
- MongoDB for database operations abstraction and easy scalabilty. - Easy to add more data, diferent collections etc.

# INSTALL
- Install mongo: https://docs.mongodb.com/manual/installation/
- Install gems with bundle (Gemfile provided)
- Run app with shotgun -> $ shotgun config.ru --port 3000
- Open webrowser to http://localhost:3000
- Two end points to test
  - / -> with params(category,location, district), lsit activities
  - /recommend_me -> with params(category, range (10:00-20:00)) recomends the best activity in time range

# TEST
  - I made a simple test suite for show you i know what is test, tdd, etc. but time is limited ;)
  - to run it: $ MONGOID_ENV=development ruby test/activity_test.rb