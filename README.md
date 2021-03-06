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

This is a Ruby on Rails project using [PostgreSQL](https://www.postgresql.org). At a high level the following steps are required:

* Set up your environment so that Ruby on Rails can run locally. 
* Clone this repo into a project directory
* Install your gems (e.g. `bundle install`)
* Set up a PostgreSQL database server. Create a user that has `CREATE` privileges if you want the rails project to build your database during setup (or, if in development, simply make your user a `superuser`).
* Create a `config/database.yml` using the login setting from your database setup. There is an example config file named `config/database.yml.example` that can be used as a template.
* Initialize your database:
    * `rake db:create`
    * `rake db:migrate`

Run Rails Server
----------------

Fire up the rails server (e.g. `rails s -p 3030`), if everything is working correctly you should see an empty front-end at [localhost:3030](http://localhost:3030).


Load Data
---------

WARNING: This project is essentially just a front end tool for three large data files. The raw file size is approximately 45G and the processed import will generate approximately 280M rows. The full injest time (not counting file downloads) can take over 24 hours on a mid-range desktop computer.

Download the three individual data files–`ol_dump_editions_latest.txt.gz`, `ol_dump_editions_latest.txt.gz` and `ol_dump_editions_latest.txt.gz`–from OpenLibrary.org and extract them into a directory (e.g. `/path/to/dowloads/OpenLibrary/`). Run the following rake tasks:

* `rake etl:load_authors[/path/to/downloads/OpenLibrary]`
* `rake etl:load_works[/path/to/downloads/OpenLibrary]`
* `rake etl:load_editions[/path/to/downloads/OpenLibrary]`
* `rake generate_tokens`
* or a catch-all task: `rake load_all[/path/to/downloads/OpenLibrary]`

Screenshot
----------

![Screenshot](screenshot.png)

Model
-----

![ERD Diagram](https://github.com/palmergs/open-library-d3/blob/master/docs/erd.png)


Next Steps
----------

* Animate chart rending
* Add [Liquid Fire](https://github.com/ember-animation/liquid-fire) for route transitions
* Intelligent wrap of pie chart labels
* Sidebar visualization of terms 


Notes 2021
----------

This appears to work after updating the Rails version to 4.2 and adding a pin on ember-inflector to 2.2.0 under node 10.x.  
