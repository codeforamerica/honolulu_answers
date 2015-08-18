[Honolulu Answers](https://web.archive.org/web/20140803055556/http://answers.honolulu.gov/) is a new approach to make it easier for people to navigate city information and services quickly. It's a citizen-focused website that is question-driven, with clean, easy-to-navigate design. Unlike a portal destination, Honolulu Answers is like Google -- type in anything, and it probably gives you the answer you're looking for, using the words you know. Every page on the site is an answer to a potential Google search question by a citizen, written in simple, friendly language, as if you'd asked your neighbor a question. The content is organized based on citizen understanding, the intuitive way you'd think of a problem, not the way the city is organized internally.

Honolulu Answers is designed to be very user-friendly. It declutters the govt website experience, and it solves a problem people ordinarily have. And we hope it makes people's lives easier. Inspired by Gov.uk, Honolulu Answers is a first-of-its-kind for municipal government, a partnership between Code for America and the City & County of Honolulu.

## First, a big Thank You:

* Search results are aided by a thesaurus service provided by [words.bighugelabs.com](http://words.bighugelabs.com/).
* Background photo courtesy of [Royal Realty](http://royalrealtyllc.com/)


## Deploying Locally

**If you are using OS X Snow Leopard, Lion or Mountain Lion, please follow this guide which will take you through the setup procedure**

Mac OS X is best supported by Honolulu Answers, since it is what most of us at Code for America use. Ubuntu (and therefore presumeably other linux distributions) are also supported.  Windows is currently unsupported and untested.  

[Instructions for OS X 10.8 Mountain Lion](https://github.com/codeforamerica/honolulu_answers/wiki/Installation-Instructions-for-OS-X-10.8-Mountain-Lion)

Slightly outdated Ubuntu instructions are available [here](https://github.com/codeforamerica/honolulu_answers/wiki/Installation-Instructions-for-Ubuntu-12.04-Precise).


## Usage
    
    $ foreman start

## Deploying to Heroku
    
See the wiki for up-to-date instructions:

[https://github.com/codeforamerica/honolulu_answers/wiki/Installation-Instructions-for-OS-X-10.8-Mountain-Lion#deploying-on-heroku](https://github.com/codeforamerica/honolulu_answers/wiki/Installation-Instructions-for-OS-X-10.8-Mountain-Lion#deploying-on-heroku)

## Testing

`foreman run bundle exec rake spec` command will run the current tests, these test need to be expanded.

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

## License

Copyright (c) 2012, Code for America.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Code for America nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


[![Code for America Tracker](http://stats.codeforamerica.org/codeforamerica/honolulu_answers.png)][tracker]

[tracker]: http://stats.codeforamerica.org/projects/honolulu_answers
