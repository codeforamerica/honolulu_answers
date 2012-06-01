# Honolulu Answers

## Installation

    $ bundle install
    $ rake db:create
    $ rake db:migrate

To setup some example data:
    $ rake db:seed  

## Configuration

### Setting up Searchify

We use the [Searchify](https://addons.heroku.com/searchify) heroku addon to power the search index for honolulu answers. In order to use this in development you can either run a copy of Indextank (which is what searchify is built on) or add the searchify addon to a heroku app, and copy the provided search api endpoint to your .env file.


### Environment Vars

Honolulu Answers uses Environment variables for configuration. It expects `SEARCHIFY_API_URL` to be set to the searchify endpoint (which can be retrived from `heroku config` once searchify is an addon for your app)

`foreman` is a great tool for checking your Procfile used for heroku, and running your application locally. When running `foreman start` this will load enivronment variables from `.env` if that file is found.  

Included in this project is an example of what the `.env` file should include. In order to use this make a copy and replace the values appropriate values for your setup.

    $ cp .env.sample .env

Now edit `.env` to set the correct url to the searchify endpoint.

### DB Login

Also included `config/dblogin.yml.sample` copy this file too

    $ cp config/dblogin.yml.sample config/dblogin.yml

Now if you need to set login credentials for your database that that are different then the default, you can do it in `config/dblogin.yml`

Both `config/dblogin.yml` and `.env` are added to the `.gitignore` so changes should not be committed, dont commit passwords :)


## Usage
    
    $ rails s

With Foreman (used to load .env):
    
    $ foreman start

## Deploying to Heroku
    
    $ heroku create honoluluanswers --stack cedar
    $ git push heroku master
    $ heroku run rake db:migrate
    $ heroku addons:add searchify:small

## Testing

`rake` command will run the current tests, these test need to be expanded.

## Contributing
In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

[free-sw]: http://www.fsf.org/licensing/essays/free-sw.html

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by translating to a new language
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues][]
* by reviewing patches
* [financially][]

[issues]: https://github.com/codeforamerica/honolulu_answers/issues
[financially]: https://secure.codeforamerica.org/page/contribute

## Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. You can indicate support for an existing issue by
voting it up. When submitting a bug report, please include a [Gist][] that
includes a stack trace and any details that may be necessary to reproduce the
bug, including your gem version, Ruby version, and operating system. Ideally, a
bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## Submitting a Pull Request
1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add tests for your feature or bug fix.
5. Run `bundle exec rake test`. If your changes are not 100% covered, go back
   to step 4.
6. Commit and push your changes.
7. Submit a pull request. Please do not include changes to the gemspec or
   version file. (If you want to create your own version for some reason,
   please do so in a separate commit.)

## Roadmap
* Support other search indexes backends/services (perhaps just fulltext search in DB as a fallback)
* A comprehensive admin component
* Results tailored to current location

## Supported Ruby Versions
This library aims to support and is [tested against][travis] the following Ruby
implementations:

 * Ruby 1.9.3

If something doesn't work on one of these interpreters, it should be considered
a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the versions listed
above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2012 Code for America. See [LICENSE][] for details.

[license]: https://github.com/codeforamerica/cfa_template/blob/master/LICENSE.mkd

[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/honolulu_answers.png)][tracker]

[tracker]: http://stats.codeforamerica.org/projects/honolulu_answers
