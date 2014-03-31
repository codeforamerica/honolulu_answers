Query Magic -- NLP To enhance your searches with query expansion.
=================================================================

## DESCRIPTION

Query Magic is a __ that performs Natural Language Processing (NLP) on the text within your application, in order to improve search results and provide search related functionality which is independent of your search providor.  This includes:

* Stemming. (Porter Stemming algorithm).
* Morphological analysis (Double Metaphone algorithm).
* Synonym creation (Big Huge Thesaurus).
* Spelling correction (with Hunspell).

This Gem packages together many tools and makes them available to your web application.


## INSTALLATION

    $ gem 'query_magic'
    $ bundle install
    $ rake query_magic:install

## USAGE

To enable the gem for your Rails app, add the following line to each Article on which you want to perform the analysis

    `class MyModel < ActiveRecord::Base`
      `query_magic[, :on => [:field1, :field2, 'relation1.field1'...]`
      ...
    end

The `:on => ...` option takes an array of fields which you wish to analyse. You can use strings here to pass in fields from ActiveRecord relations.  If you don't supply this option, Query Magic will anaylse every text and String column of the model.

Once you've specified which fields you want analysed, analyse the data with:

    `rake query_magic:analyse_all`

Each time a new instance of a model is saved, any changes will be reflected in the data collected by the analysis.

The result of this is the following:

* 



