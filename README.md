Ruby/ProgressBar: A Text Progress Bar Library for Ruby
================================

The **ultimate** text progress bar library for Ruby!  It'll **SMASH YOU OVER THE HEAD** with a **PURE RUSH** of progress bar excitement!

Don't miss out on what all the kids are talking about!  If you want everyone to know that your gem or app can survive _in the cage_ then YOU WANT **RUBY-PROGRESSBAR**!

![The Cage](http://www.thekompanee.com/public_files/the-cage.png)

Installation
--------------------------------

First:

    gem install ruby-progressbar

Then in your script:

    require 'ruby-progressbar'

or in your Gemfile

    gem 'ruby-progressbar'

or from IRB

    irb -r 'ruby-progressbar'

Basic Usage
--------------------------------

### Creation

It's simple to get started:

    BasicProgressBar.new

Creates a basic progress bar beginning at 0, a total capacity of 100 and tells it to start.

    Progress: |                                                                       |

### Marking Progress

Every call to `#increment` will advance the bar by 1. Therefore:

    50.times { progressbar.increment }

Would output an advancing line which would end up here:

    Progress: |ooooooooooooooooooooooooooooooooooo                                    |

Advanced Usage
--------------------------------

### Options

If you would like to customize your prompt, you can pass options when you call `#new`.

    BasicProgressBar.new(:title => "Items", :starting_at => 20, :total => 200)

Will output:

    Items: |ooooooo                                                                |

The following are the list of options you can use:

* `:title` - _(Defaults to 'Progress')_ - The title of the progress bar.
* `:total` - _(Defaults to 100)_ The total number of the items that can be completed.
* `:starting_at` - _(Defaults to 0)_ The number of items that should be considered completed when the bar first starts.  This is also the default number that the bar will be set to if `#reset` is called.
* `:progress_mark` - _(Defaults to 'o')_ The mark which indicates the amount of progress that has been made.
* `:format` - _(Defaults to '%t: |%b|')_ The format string which determines how the bar is displayed.  See `Formatting` below.
* `:length` - _(Defaults to full width if possible, otherwise 80)_ The preferred width of the entire progress bar including any format options.
* `:output` - _(Defaults to STDOUT)_ All output will be sent to this object.  Can be any object which responds to `.print`.

### Changing Progress

* `#increment`: Will advance the bar's progress by 1 unit.  This is the main way of progressing the bar.
* `#decrement`: Will retract the bar's progress by 1 unit.
* `#progress=`: Will allow you to jump the amount of progress directly to whatever value you would like. _Note: This will almost always mess up your estimated time if you're using it._

### Stopping

The bar can be stopped in four ways:

* `#finish`: Will stop the bar by completing it immediately.  The current position will be advanced to the total.
* `#stop`: Will stop the bar by immediately cancelling it.  The current position will remain where it is.
* `#pause`: Will stop the bar similar to `#stop` but will allow it to be restarted where it previously left off by calling `#resume`. (Elapsed Time and Estimated Time will continue to be calculated correctly.)
* `#reset`: Will stop the bar by resetting all information.  The current position of the bar will be reset to where it began when it was created.

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
* `%a`: Elapsed (Absolute) Time
* `%e`: Estimated Time (Will Fall Back To 'ETA: ??:??:??' When It Exceeds 99:00:00)
* `%E`: Estimated Time (Will Fall Back To 'ETA: > 4 Days' When It Exceeds 99:00:00)
* `%f`: Force Estimated Time Even When Inaccurate
* `%p`: Percentage Complete represented as a whole number (ie: 82%)
* `%P`: Percentage Complete represented as a decimal number (ie: 82.33%)
* `%c`: Number of Items Currently Completed
* `%C`: Total Number of Items to be Completed
* `%b`: Progress Bar
* `%B`: Bar With Integrated Percentage (eg: `|oooo 75 oooo    |`)
* `%m`: Mirrored Progress Bar (Accumulates From The Right)
* `%%`: A Literal Percent Sign "%"

All values have an absolute length with the exception of the bar flags (ie %b, %r) which will occupy any leftover space.
More than one bar flag can be used (although I'm not sure why you would :).  If so, the remaining space will be divided up equally among them.

### Example

If you would like a bar with the elapsed time on the left and the percentage complete followed by the title on the right, you'd do this:

    BasicProgressBar.new(:format => '%a %b %p %t')

Which will output something like this:

    Time: --:--:--                                                   0% Progress

Hard to see where the bar is?  Just add your own end caps, whatever you'd like.  Like so:

    BasicProgressBar.new(:format => '%a <%b> %p %t')

Becomes:

    Time: --:--:-- <                                               > 0% Progress

Notice that the absolute length doesn't get any longer, the bar just shrinks to fill the remaining space.

### Overriding the Length

By default, the progressbar will try to be as smart as possible about how wide it can be.  Under most Unix systems, it should be as wide as the terminal will allow while still fitting on one line.  If you wish to override this behavior, you can pass in the `:length` option when creating the bar like so:

    BasicProgressBar.new(:length => 40)

Additionally, if you don't have access to the code calling the progressbar itself (say if you're using a gem like Fuubar), you can set the `RUBY_PROGRESS_BAR_LENGTH` environment variable and it will always override any other setting.

### Realtime Customization

The following items can be set at any time.  Changes cause an immediate bar refresh so no other action is needed:

* `#progress_mark=`: Sets the string used to represent progress along the bar
* `#title=`: Sets the string used to represent the items the bar is tracking (or I guess whatever else you want it to be)

Road Map
--------------------------------
We're planning on adding a bunch of really nice features to this gem over the next few weeks.  We want to keep the simple usage simple but allow for powerful features if they're needed.  Our 1.0 release is the first step in that direction.

Issues
--------------------------------

If you have problems, please create a [Github issue](https://github.com/nex3/ruby-progressbar/issues).

Credits
--------------------------------

![thekompanee](http://www.thekompanee.com/public_files/kompanee-github-readme-logo.png)

ruby-progressbar is maintained by [The Kompanee, Ltd.](http://www.thekompanee.com)

The names and logos for The Kompanee are trademarks of The Kompanee, Ltd.

Thanks
--------------------------------

Thanks to [@nex3](https://github.com/nex3) for giving us contributor access to the initial repo.
Thanks to Hiroyuki Iwatsuki for giving us access to the gem on Rubygems to allow us to push our new versions.

And a special thanks to [Satoru Takabayashi](http://namazu.org/~satoru/) who was the original author of the `progressbar` gem and who inspired us to do this rewrite.

License
--------------------------------

ruby-progressbar 1.0 is Copyright &copy; 2011 The Kompanee. It is free software, and may be redistributed under the terms specified in the LICENSE file.
ruby-progressbar 0.0.9 is Copyright &copy; 2008 [Satoru Takabayashi](http://namazu.org/~satoru/)
