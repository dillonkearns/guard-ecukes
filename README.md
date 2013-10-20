# Guard::Ecukes [![Build Status](https://secure.travis-ci.org/dillonkearns/guard-ecukes.png)](http://travis-ci.org/dillonkearns/guard-ecukes)

Guard::Ecukes allows you to automatically run [Ecukes](http://ecukes.info/) features when files are modified.

Tested on MRI Ruby 1.9.3 and 2.0.0 (< 1.9.3 is not supported).

If you have any questions please join us on our [Google group](http://groups.google.com/group/guard-dev) or on `#guard` (irc.freenode.net).

## Install

Install ruby (>= 1.9.3).
Install [Guard](https://github.com/guard/guard) using [Bundler](http://gembundler.com/) by setting up your Gemfile and running bundle install:

Make sure bundler is installed:

```bash
$ gem install bundler
```

Create a file called `Gemfile` in your project's root directory with the following:

```ruby
source 'https://rubygems.org'

gem 'guard-ecukes'
```

Then, to install guard and guard-ecukes, simply run:
```bash
$ bundle install
```

Finally, add the default Guard::Ecukes template to your `Guardfile` by running:

```bash
$ guard init ecukes
```

You should now have 3 new files to commit to your repository:
```bash
$ git status -s
?? Gemfile
?? Gemfile.lock
?? Guardfile
```

Commit all of these, and you are done! Now you can run your tests with:

```bash
$ bundle exec guard  # add a [-c option](https://github.com/guard/guard#-c--clear-option) to clear the screen after each run
```

See the [Guard usage documentation](https://github.com/guard/guard#readme) for more information.

## Guardfile

Guard::Ecukes can be adapted to all kind of projects and comes with a default template that looks like this:

```ruby
guard 'ecukes' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^([^\/]*\.el|features/support/.+\.el)$})       { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.el$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end
```

Expressed in plain English, this configuration tells Guard::Ecukes:

1. When a file within the features directory that ends in feature is modified, just run that single feature.
2. When any file within features/support directory is modified, run all features.
3. When a file within the features/step_definitions directory that ends in \_steps.rb is modified,
run the first feature that matches the name (\_steps.rb replaced by .feature) and when no feature is found,
then run all features.

Please read the [Guard documentation](http://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Options

You can pass any of the standard Ecukes CLI options using the :cli option:

```ruby
guard 'ecukes', :cli => '--reporter magnars --timeout 10'
```

### List of available options

```ruby
:cli => '--reporter magnars --timeout 10' # Pass arbitrary Ecukes CLI arguments,
                                          # default: none

:all_after_pass => false                  # Don't run all features after changed features pass
                                          # default: true

:all_on_start => false                    # Don't run all the features at startup
                                          # default: true

:run_all => { :cli => "-r progress" }     # Override any option when running all specs
                                          # default: {}

:command_prefix => 'xvfb-run'             # Add a prefix to the ecukes command such as 'xvfb-run' or any
                                          # other shell script.
                                          # The example generates: 'xvfb-run bundle exec ecukes ...'
                                          # default: nil
```

Issues
------

You can report issues and feature requests to [GitHub Issues](https://github.com/dillonkearns/guard-ecukes/issues). Try to figure out
where the issue belongs to: Is it an issue with Guard itself or with Guard::Ecukes? Please don't
ask question in the issue tracker, instead join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

When you file an issue, please try to follow to these simple rules if applicable:

* Make sure you run Guard with `bundle exec` first.
* Add debug information to the issue by running Guard with the `--debug` option.
* Add your `Guardfile` and `Gemfile` to the issue.
* Make sure that the issue is reproducible with your description.

## Development

- Source hosted at [GitHub](https://github.com/dillonkearns/guard-ecukes).

Pull requests are very welcome! Please try to follow these simple rules if applicable:

* Please create a topic branch for every separate change you make.
* Make sure your patches are well tested.
* Update the README.
* Please **do not change** the version number.

For questions please join us in our [Google group](http://groups.google.com/group/guard-dev) or on
`#guard` (irc.freenode.net).

## Author

Forked from [@netzpirat](https://twitter.com/#!/netzpirat)'s [guard-cucumber](https://github.com/netzpirat/guard-cucumber), developed by Michael Kessler, sponsored by [mksoft.ch](https://mksoft.ch).

## Contributors

See the GitHub list of [contributors](https://github.com/dillonkearns/guard-ecukes/contributors).

## Acknowledgment

The [Guard Team](https://github.com/guard/guard/contributors) for giving us such a nice pice of software
that is so easy to extend, one *has* to make a plugin for it!

All the authors of the numerous [Guards](http://github.com/guard) available for making the Guard ecosystem
so much growing and comprehensive.

## License

(The MIT License)

Copyright (c) 2010-2013 Michael Kessler

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
