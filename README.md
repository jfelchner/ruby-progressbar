Ruby/ProgressBar: A Text Progress Bar Library for Ruby
================================

The **ultimate** text progress bar library for Ruby!  It'll **SMASH YOU OVER THE HEAD** with a **PURE RUSH** of progress bar excitement!

Don't miss out on what all the kids are talking about!  If you want everyone to know that your gem or app can survive _in the cage_ then YOU WANT **RUBY-PROGRESSBAR**!

![The Cage](http://www.thekompanee.com/public_files/the-cage.png)

Supported Rubies
--------------------------------
* MRI Ruby 1.8.7
* MRI Ruby 1.9.2
* MRI Ruby 1.9.3
* JRuby (in 1.8 compat mode)
* JRuby (in 1.9 compat mode)

It's Better Than The Other 186,312 Progress Bar Libraries Because...
--------------------------------
* Full test suite [![Build Status](https://secure.travis-ci.org/jfelchner/ruby-progressbar.png?branch=master)](http://travis-ci.org/jfelchner/ruby-progressbar)
* Used by tons of other open source projects (which means we find out about bugs quickly)
* It's pretty [freakin' sweet](https://www.youtube.com/watch?v=On3IoVhf_GM)
* We have a road map of new features to make it even better
* And most importantly... our awesome [contributors](#contributors)

Installation
--------------------------------

First:

```ruby
gem install ruby-progressbar
```

Then in your script:

```ruby
require 'ruby-progressbar'
```

or in your Gemfile

```ruby
gem 'ruby-progressbar'
```

or from IRB

```ruby
irb -r 'ruby-progressbar'
```

Basic Usage
--------------------------------

### Creation

It's simple to get started:

```ruby
ProgressBar.create
```

Creates a basic progress bar beginning at `0`, a total capacity of `100` and tells it to start.

    Progress: |                                                                       |

### Marking Progress

Every call to `#increment` will advance the bar by `1`. Therefore:

```ruby
50.times { progressbar.increment }
```

Would output an advancing line which would end up here:

    Progress: |===================================                                    |

Advanced Usage
--------------------------------

### Options

If you would like to customize your prompt, you can pass options when you call `.create`.

```ruby
ProgressBar.create(:title => "Items", :starting_at => 20, :total => 200)
```

Will output:

    Items: |=======                                                                |

The following are the list of options you can use:

* `:title` - _(Defaults to `Progress`)_ - The title of the progress bar.
* `:total` - _(Defaults to `100`)_ The total number of the items that can be completed.
* `:starting_at` - _(Defaults to `0`)_ The number of items that should be considered completed when the bar first starts.  This is also the default number that the bar will be set to if `#reset` is called.
* `:progress_mark` - _(Defaults to `=`)_ The mark which indicates the amount of progress that has been made.
* `:format` - _(Defaults to `%t: |%B|`)_ The format string which determines how the bar is displayed.  See [**Formatting**](#formatting) below.
* `:length` - _(Defaults to full width if possible, otherwise `80`)_ The preferred width of the entire progress bar including any format options.
* `:output` - _(Defaults to `STDOUT`)_ All output will be sent to this object.  Can be any object which responds to `.print`.
* `:smoothing` - _(Defaults to `0.1`)_ See [**Smoothing Out Estimated Time Jitters**](#smoothing-out-estimated-time-jitters) below.

### Changing Progress

* `#increment`: Will advance the bar's progress by `1` unit.  This is the main way of progressing the bar.
* `#decrement`: Will retract the bar's progress by `1` unit.
* `#progress +=`: Will allow you to increment by a relative amount.
* `#progress -=`: Will allow you to decrement by a relative amount.
* `#progress=`: Will allow you to jump the amount of progress directly to whatever value you would like. _Note: This will almost always mess up your estimated time if you're using it._

### Stopping

The bar can be stopped in four ways:

* `#finish`: Will stop the bar by completing it immediately.  The current position will be advanced to the total.
* `#stop`: Will stop the bar by immediately cancelling it.  The current position will remain where it is.
* `#pause`: Will stop the bar similar to `#stop` but will allow it to be restarted where it previously left off by calling `#resume`. _Note: Elapsed Time and Estimated Time will stop being affected while the bar is paused._
* `#reset`: Will stop the bar by resetting all information.  The current position of the bar will be reset to where it began when it was created. _(eg if you passed `:starting_at => 5` when you created the bar, it would reset to `5` and not `0`)_

### Finishing

* See `#finish` above.

_Note: The bar will be finished automatically if the current value ever becomes equal to the total._

### Refreshing

* If you need to have the bar be redisplayed to give your users more of a "real-time" feel, you can call `#refresh` which will not affect the current position but will update the elapsed and estimated timers.

Formatting
--------------------------------

The format of the progress bar is extremely easy to customize.  When you create the progress bar and pass the `:format` option, that string will be used to determine what the bar looks like.

The flags you can use in the format string are as follows:

* `%t`: Title
* `%a`: Elapsed (absolute) time
* `%e`: Estimated time (will fall back to `ETA: ??:??:??` when it exceeds `99:00:00`)
* `%E`: Estimated time (will fall back to `ETA: > 4 Days` when it exceeds `99:00:00`)
* `%f`: Force estimated time to be displayed even if it exceeds `99:00:00`
* `%p`: Percentage complete represented as a whole number (eg: `82`)
* `%P`: Percentage complete represented as a decimal number (eg: `82.33`)
* `%c`: Number of items currently completed
* `%C`: Total number of items to be completed
* `%B`: The full progress bar including 'incomplete' space (eg: `==========    `)
* `%b`: Progress bar only (eg: `==========`)
* `%w`: Bar With Integrated Percentage (eg: `==== 75 ====`)
* `%i`: Display the incomplete space of the bar (this string will only contain whitespace eg: `    `)
* `%%`: A literal percent sign `%`

All values have an absolute length with the exception of the bar flags (eg `%B`, `%b`, etc) which will occupy any leftover space.
You can use as many bar flags as you'd like, but if you do weird things, weird things will happen; so be wary.

### Example

If you would like a bar with the elapsed time on the left and the percentage complete followed by the title on the right, you'd do this:

```ruby
ProgressBar.create(:format => '%a %B %p%% %t')
```

Which will output something like this:

    Time: --:--:--                                                   0% Progress

Hard to see where the bar is?  Just add your own end caps, whatever you'd like.  Like so:

```ruby
ProgressBar.create(:format => '%a <%B> %p%% %t')
```

Becomes:

    Time: --:--:-- <                                               > 0% Progress

Want to put an end cap on your bar? Nothing special, just use the bar flag `%b` combined with the incomplete space flag `%i` like so:

```ruby
ProgressBar.create(:format => '%a |%b>>%i| %p%% %t', :starting_at => 10)
```

Becomes:

    Time: --:--:-- |====>>                                        | 10% Progress

Notice that the absolute length doesn't get any longer, the bar just shrinks to fill the remaining space.

### Overriding the Length

By default, the progressbar will try to be as smart as possible about how wide it can be.  Under most Unix systems, it should be as wide as the terminal will allow while still fitting on one line.  If you wish to override this behavior, you can pass in the `:length` option when creating the bar like so:

```ruby
ProgressBar.create(:length => 40)
```

Additionally, if you don't have access to the code calling the progressbar itself (say if you're using a gem like Fuubar), you can set the `RUBY_PROGRESS_BAR_LENGTH` environment variable and it will always override any other setting.

_Note: If the terminal width is less than 20 characters or ruby-progressbar is being used on a non-*nix system, the bar will default to an 80 character width._

### Realtime Customization

The following items can be set at any time.  Changes cause an immediate bar refresh so no other action is needed:

* `#progress_mark=`: Sets the string used to represent progress along the bar.
* `#title=`: Sets the string used to represent the items the bar is tracking (or I guess whatever else you want it to be).
* `#format(format_string)`: If you need to adjust the format that the bar uses when rendering itself, just pass in a string in the same format as describe [above](#formatting).

## In The Weeds

This is some stuff that makes ruby-progressbar extra awesome, but for the most part it "Just Works" and you won't have to even know it's there, but if you're curious like us, here it is.

### Times... They Are A Changin'

#### Smoothing Out Estimated Time Jitters

Sometimes when you're tracking progress, you could have some items which take significantly longer than others.  When this is the case, the ETA gauge can vary wildly from increment to increment.

__RUBY PROGRESS BAR TO THE RESCUE!__

Thanks to [@L2G](https://github.com/L2G) and 'the maths' you can pass the `:smoothing` option when creating a new bar and it will use an exponentially smoothed average rather than a linear one.  A value of `0.0` means no smoothing and is equivalent to the classic behavior.  A value of `1.0` is the maximum amount of smoothing.  Any values between those two are valid. `0.1` is the default.

```ruby
ProgressBar.create(:smoothing => 0.6)
```

#### Time Mocking Support

When mocking time, the concept of when `now` is becomes distorted.  You can imagine that because ruby-progressbar tracks elapsed and estimated times, if it used the mocked version of `now` the results would be very undesirable.  Fortunately, if you use one of our supported Ruby time mocking libraries, your elapsed and estimated times will appear correctly no matter when your 'now' is.  Currently supported are:

  * [Timecop](https://github.com/jtrupiano/timecop)
  * [Delorean](https://github.com/bebanjo/delorean)

Road Map
--------------------------------
We're planning on adding a bunch of really nice features to this gem over the next few weeks.  We want to keep the simple usage simple but allow for powerful features if they're needed.  Our `1.0` release is the first step in that direction.

Issues
--------------------------------

If you have problems, please create a [Github issue](https://github.com/nex3/ruby-progressbar/issues).

Credits
--------------------------------

![thekompanee](http://www.thekompanee.com/public_files/kompanee-github-readme-logo.png)

ruby-progressbar is maintained by [The Kompanee, Ltd.](http://www.thekompanee.com)

The names and logos for The Kompanee are trademarks of The Kompanee, Ltd.

Contributors
--------------------------------
* [Lawrence Leonard "Larry" Gilbert](https://github.com/L2G)
* [Aleksei Gusev](https://github.com/hron)
* [Yves Senn](https://github.com/senny)
* [Nathan Weizenbaum](https://github.com/nex3)
* [Oleg Dashevskii](https://github.com/be9)
* [Chris Griego](https://github.com/cgriego)
* [Tim Harper](https://github.com/timcharper)
* [Chalo Fernandez](https://github.com/chalofa)
* [Laust Rud Jacobsen](https://github.com/rud)
* [Ryan Wood](https://github.com/ryanwood)
* [Jim Benton](https://github.com/jim)

Thanks
--------------------------------

Thanks to [@nex3](https://github.com/nex3) for giving us contributor access to the initial repo.
Thanks to Hiroyuki Iwatsuki for giving us access to the gem on [rubygems.org](http://rubygems.org) to allow us to push our new versions.

And a special thanks to [Satoru Takabayashi](http://namazu.org/~satoru/) who was the original author of the `progressbar` gem and who inspired us to do this rewrite.

License
--------------------------------

ruby-progressbar 1.0 is Copyright &copy; 2011-2012 The Kompanee. It is free software, and may be redistributed under the terms specified in the LICENSE file.
ruby-progressbar 0.9.0 is Copyright &copy; 2008 [Satoru Takabayashi](http://namazu.org/~satoru/)
