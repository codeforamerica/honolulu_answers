## Information Architecture

### Article

The Article model backs an articles table, with each row representing a piece of content on the site.  At the moment, the site only contains articles but will soon also contain guides, which may or may not be represented by the Article model.

### User

The User model backs a users tablem which is used for admin and content creation.

### Wordcount

The wordcounts table represents a wordcount for an article.  In other words, for every keyword in the article there is a row in the wordcounts table which records how many times that word occurs. The wordcounts table also acts as a join table linking the Article and Keyword models.  `Article has_many :keywords, :through => :wordcounts`.  

### Keyword

The keywords table stores information about the content across the site.  Each unique word has some properties which are computed during article creation (or when an article is edited).

* name - the name of the keyword; the keyword itself
* metaphone - A phonetic representation of the word, calulcated using the Double Metaphone algorithm(http://en.wikipedia.org/wiki/Metaphone#Double_Metaphone).  For example,  ["SM0","XMT"] or ["RGK", nil].
* stem - a truncated version of the word which attempts to "remove common morphological and infexlional endings from words in English". For example, 'general' --> 'gener' and 'employment' --> 'employ'. Uses the Porter stemming algorithm. (http://tartarus.org/~martin/PorterStemmer/)
* synonyms - a list of synonyms for the keyword. This is naieve, as it does not attempt to determine whether the keyword is contextually being used as a verb, adjective or noun.  Hence, some of the synonyms will be inappropriate.  Uses the BigHugeThesaurus API. (http://words.bighugelabs.com/).  

You can also call `keyword.articles()` to see which articles use the keyword, and `keyword.count()` to total the number of times a keyword appears across the site.
