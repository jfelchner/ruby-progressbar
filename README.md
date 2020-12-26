Ruby/ProgressBar
================================================================================

[![Gem Version](https://img.shields.io/gem/v/ruby-progressbar.svg)](https://rubygems.org/gems/ruby-progressbar) ![Rubygems Rank Overall](https://img.shields.io/gem/rt/ruby-progressbar.svg) ![Rubygems Rank Daily](https://img.shields.io/gem/rd/ruby-progressbar.svg) ![Rubygems Downloads](https://img.shields.io/gem/dt/ruby-progressbar.svg) [![Build Status](https://github.com/thekompanee/fuubar/workflows/Build/badge.svg)](http://travis-ci.org/jfelchner/ruby-progressbar) [![Code Climate](https://codeclimate.com/github/jfelchner/ruby-progressbar.svg)](https://codeclimate.com/github/jfelchner/ruby-progressbar)

<img src="https://kompanee-public-assets.s3.amazonaws.com/readmes/ruby-progressbar-cage.png" align="right" />

The **ultimate** text progress bar library for Ruby!  It'll **SMASH YOU OVER THE
HEAD** with a **PURE RUSH** of progress bar excitement!

Don't miss out on what all the kids are talking about!  If you want everyone to
know that your gem or app can survive _in the cage_ then YOU WANT
**RUBY-PROGRESSBAR**!

<br><br><br>

It's Better Than The Other 186,312 Progress Bar Libraries Because
--------------------------------------------------------------------------------

* It has [stood the test of time][history] (2008-today)

* Full test suite

* [_**ZERO**_ dependencies][gemspec]

* Used by [tons of other open source projects][dependencies] (which means we
  find out about bugs quickly)

* It's pretty [freakin' sweet](https://www.youtube.com/watch?v=On3IoVhf_GM)

* And most importantly... our awesome [contributors][contributors]

Basic Usage
--------------------------------------------------------------------------------

### Creation

It's simple to get started:

```ruby
progressbar = ProgressBar.create
```

Creates a basic progress bar beginning at `0`, a maximum capacity of `100` and
tells it to start.

```text
Progress: |                                                                       |
```

### Marking Progress

Every call to `#increment` will advance the bar by `1`. Therefore:

```ruby
50.times { progressbar.increment }
```

Would output an advancing line which would end up here:

```text
Progress: |===================================                                    |
```

### Animation

![Basic Usage Marking Progress](http://kompanee-public-assets.s3.amazonaws.com/readmes/ruby-progressbar-basic-usage-marking-progress-2.gif)

Full Reference
--------------------------------------------------------------------------------

There's gotten to be too much awesome to pack into one page.  Visit the
[wiki][wiki] for the full documentation.

Issues
--------------------------------------------------------------------------------

If you have problems, please create a [Github issue][issues].

Credits
--------------------------------------------------------------------------------

![The Kompanee][kompanee-logo]

ruby-progressbar is maintained by [The Kompanee, Ltd.][kompanee-site]

The names and logos for The Kompanee are trademarks of The Kompanee, Ltd.

License
--------------------------------------------------------------------------------

ruby-progressbar 1.0 is Copyright &copy; 2011-2021 The Kompanee. It is free
software, and may be redistributed under the terms specified in the LICENSE
file.
ruby-progressbar 0.9.0 is Copyright &copy; 2008 [Satoru Takabayashi][satoru]

[contributors]:  https://github.com/jfelchner/ruby-progressbar/graphs/contributors
[dependencies]:  https://github.com/jfelchner/ruby-progressbar/network/dependents
[gemspec]:       https://github.com/jfelchner/ruby-progressbar/blob/master/ruby-progressbar.gemspec
[history]:       https://github.com/jfelchner/ruby-progressbar/wiki/History
[issues]:        https://github.com/jfelchner/ruby-progressbar/issues
[kompanee-logo]: https://kompanee-public-assets.s3.amazonaws.com/readmes/kompanee-horizontal-black.png
[kompanee-site]: http://www.thekompanee.com
[satoru]:        http://0xcc.net
[wiki]:          https://github.com/jfelchner/ruby-progressbar/wiki
