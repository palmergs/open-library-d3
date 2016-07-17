Open Library Visualizations with D3.js
=======================================

Goals
-----


This project is an experiment in working with large datasets of semi-formatted data
made available by the [OpenLibrary.org](https://openlibrary.org) project. 

The project experiments with the following technologies:

* [Ruby on Rails](http://rubyonrails.org) (4.1.x) as an API server and to handle the underlying ETL 
  (extract / transform / load) operations
* [JSON API](http://jsonapi.org) a specification for the formatting of JSON responses
* [Ember.js](https://emberjs.com) (2.5.x) as a single page JavaScript framework
* [D3.js](https://d3js.org) (4.1.x) for visualizations

License
-------

This project is available under the MIT license. The use of the OpenLibrary.org data files
[Open Library Data Dumps](https://openlibrary.org/developers/dumps) is subject to the 
Internet Archive's [Terms of Use](https://archive.org/about/terms.php).

Project Setup
-------------

This is a standard rails project using [PostgreSQL](https://www.postgresql.org). At a high level the following steps are required:

* Set up your environment so that Ruby on Rails can run locally. 
* Clone this repo into a project directory
* Install your gems (e.g. `bundle install`)
* Set up a PostgreSQL database server. Create a user that has `CREATE` privileges if you want the rails project to build your database during setup (or, if in development, simply make your user a `superuser`).
* Create a `config/database.yml` using the login setting from your database setup. There is an example config file named `config/database.yml.example` that can be used as a template.
* Initialize your database:
** `rake db:create`
** `rake db:migrate`

TODO
----

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.
