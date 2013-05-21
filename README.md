LanguageClassifer
=================

[![Build Status](https://travis-ci.org/FluffyJack/LanguageClassifier.png?branch=master)](https://travis-ci.org/FluffyJack/LanguageClassifier)

Download LanguageClassifier, train it with text files that you know the language/category of, then have it classify text files that you don't know the language/category of.

LanguageClassifer uses a simplified version of Bayes' Law, an algorithm used in spam detection systems.

This script can be used to classify anything. It will take plain text files and train the system to recognize the words that are more likely to appear in each category. It can then use that data to classify text files from unknown categories.

Installation & Use
------------------

First you will need bundler, run `gem install bundler`.

Then clone this repository with `git clone git://github.com/FluffyJack/LanguageClassifier.git` then `cd LanguageClassifier`. Then run `bundle install`.

You must then train up the system. To do so, you will need several plain text files of different langugages (at least one for each language you might need to classify). Then for each file you have to train the system with, run the command (from within the LanguageClassifier directory) `bin/classify train -f FILE_PATH -c LANGUAGE_OR_CATEGORY`. Or you can use the sample ones provided by running `bin/classify seed`.

After you've completely trained the system as much as you can, you can then classify a file's language with the command `bin/classify classify -f FILE_PATH`. Running that command will print out the matching language or category.

Notes
-----

* Persistance: To ensure training is persisted after each command is run, I have set up the script to use [madeleine](https://github.com/ghostganz/madeleine).
* Bayes' Law: This script doesn't apply Bayes' Law in full, but a simplified version that gets the job done.

Commands
--------

* __Training__: `bin/classify train -f FILE_PATH -c CATEGORY`
* __Classification__: `bin/classify classify -f FILE_PATH`
* __Seed__: `bin/classify seed`
* __Clear All Data__: `bin/classify clear`

Contributions
-------------

If you actually find this interesting, go ahead and contribute. This started as a project for me to send as an example of my work to a potential employer though.

License
-------

Ruby on Rails is released under the [MIT License](http://www.opensource.org/licenses/MIT).