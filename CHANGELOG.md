Version v1.7.1 - December 21, 2014
================================================================================

Bugfix
--------------------------------------------------------------------------------
  * ETA works again, when ProgressBar is initialized with a non zero
    starting_at.

Uncategorized
--------------------------------------------------------------------------------
  * Describe the wiki link
  * Inline the cage image in the README
  * THE CAGE
  * Remove superfluous subtitle
  * Remove sections from the README that were moved to the Wiki
  * Add link to wiki
  * Update logo

Version v1.7.0 - November 4, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * Massive internal refactoring. Now 236% faster!
  * Add Timer#restart

Version v1.6.1 - October 30, 2014
================================================================================

Uncategorized
--------------------------------------------------------------------------------
  * Update readme about output option
  * Display warnings when testing

Bugfix
--------------------------------------------------------------------------------
  * Remove warnings from uninitialized instance variable
  * Instance variable @started_at not initialized
  * Instance variable @out_of_bounds_time_format not initialized
  * Change private attributes to protected
  * `*' interpreted as argument prefix
  * Prefix assigned but unused variables with underscores
  * Ambiguous first argument

Version v1.6.0 - September 20, 2014
================================================================================

Feature
--------------------------------------------------------------------------------
  * Add ability to disable auto-finish
  * Add SCSS lint configuration
  * Update JSHint config with our custom version
  * Add right-justified percentages - Closes #77

Bugfix
--------------------------------------------------------------------------------
  * Don't allow title to change for non-TTY output
  * Percentage formatter failed when total was 0 or unknown

Version v1.5.1 - May 14, 2014
================================================================================

Uncategorized
--------------------------------------------------------------------------------
  * Make grammar and spelling corrections in the README
  * Add the ability to scale the rate component
  * Add notes to the README about the new format components
  * Add the %R flag to the formatting to show the rate with 2 decimal places of
    precision
  * Remove unused molecule cruft
  * Add specs to make sure that rate works even if the bar is started in the
    middle
  * Add base functionality for the rate component
  * Add Slack notification to Travis builds
  * Upgrade rspectacular to v0.21.6
  * Upgrade rspectacular to v0.21.5
  * Upgrade rspectacular to v0.21.4
  * Upgrade rspectacular to v0.21.3
  * Upgrade rspectacular to v0.21.2
  * Add badges to the README
  * Upgrade rspectacular to v0.21.1
  * Lower Timecop version for Ruby 1.8 compatibility
  * Lower rake version to 0.9.6 so that it will be compatible with Ruby 1.8
  * Update rspectacular to 0.21
  * Add CODECLIMATE_REPO_TOKEN as a secure Travis ENV variable
  * Upgrade rspectacular to v0.20
  * Add the Code Climate test reporter gem
  * Add Ruby 2.1 to Travis
  * Convert to RSpec 3

Feature
--------------------------------------------------------------------------------
  * The running average is always set back to 0 when the bar is reset

Version v1.4.2 - March 1, 2014
================================================================================

  * Improve estimated timer for short durations
  * Remove useless protection
  * README Update
  * Slight formatting changes on the PACMAN example to make it consistent with
    the others
  * Pacman-style progressbar

Version v1.4.1 - January 26, 2014
================================================================================

  * Change from 'STDOUT.puts' to the more appropriate 'Kernel.warn'
  * Add another spec which tests this in a different way
  * Add an acceptance spec to mimic running fuubar with no specs
  * Makes Timer#stop a no-op unless it has first been started.

Version v1.4.0 - December 28, 2013
================================================================================

  * Displaying the call stack was probably too much
  * Upgrade fuubar
  * Add an error specifically for invalid progress so that, in parent libraries,
    it can be caught properly
  * Use the splat operator just to be clear
  * Fix an issue with the estimated timers blowing up if the total was nil -
    Closes #62
  * Changed my mind. Rather than checking if the bar is stopped/started just
    blow up when the attempt is made to increment/decrement the bar to an invalid
    value
  * Remove the CannotUpdateStoppedBarError
  * Changes to the total should also be considered a change in progress and
    should therefore not be allowed for a stopped bar
  * Add a warning that any changes to progress while the bar is stopped, will
    eventually be an exception
  * Use the helper to divide the seconds. Don't know why I didn't do this before
  * When finishing the bar, we also should stop the timers
  * When checking 'finished?' make sure we check all progressables
  * Always thought it was weird that the 'finished?' check was in the update
    method
  * Move the 'finished' logic into the progressable
  * Rather than specifying @elapsed_time explicitly, use the with_timers helper
  * Add a method to check to see whether the bar has been started
  * Extract logic for updating progress into a 'update_progress' method
  * Add placeholder for an Error which will be used in v2.0.0
  * Update the copyright in the README to 2014 (we're almost there :)
  * Add 'Zero dependencies' to the README as a beneifit of using
    ruby-progressbar

Version v1.3.2 - December 15, 2013
================================================================================

  * Try to fix issues with testing on 1.8 and 1.9 when 'console/io' is not
    available
  * Remove rspectacular so we can get the specs to pass on 1.8 and 1.9.2

Version v1.3.1 - December 15, 2013
================================================================================

  * Even if the throttle rate is passed in as nil, use the default regardless

Version v1.3.0 - December 15, 2013
================================================================================

  * Remove the 'Road Map' section in the README
  * Add notes to the README about non-TTY output
  * Add notes to the CHANGELOG
  * Give the bar the option of whether or not to automatically start or if
    `#start` has to be explicitly called
  * Default to a non-TTY-safe format if there is no TTY support when outputting
    the bar
  * Do not output the bar multiple times if `#resume` is called when the bar is
    already started
  * Do not output the bar multiple times if `#stop` is called when the bar is
    already stopped
  * Do not output multiple bars if `#finish` is called multiple times
  * Change progressbar variables in specs to be `let`'s instead
  * Change output variables in specs to be `let`'s instead
  * Update Gemfile.lock to use HTTPS for Rubygems
  * Add Ruby 2.0.0 to the README as a supported Ruby version
  * Test with Ruby 2.0.0 on Travis CI
  * Use HTTPS RubyGems source
  * Added an option to set the :remainder_mark (along the lines of
    :progress_mark) that allows the user to set the character used to represent
    the remaining progress to be made along the bar.
  * Add specs for the ANSI color code length calculation
  * Name the regex for the ANSI SGR codes so that it's more clear what we're
    doing
  * Remove comment
  * allows to inclue ANSI SGR codes into molecules, preserving the printable
    length
  * Switch from using 'git ls-files' to Ruby Dir globbing - Closes #54

Version v1.2.0 - August 12, 2013
================================================================================

  * Add note to CHANGELOG about TTY updates
  * Update benchmark script
  * Update logic to describe the bar as being 'stopped' also when it is
    'finished'
  * Only print the bar output if we're printing to a TTY device, or any device
    as long as the bar is finished
  * Switch to instead of STDOUT so that it can be properly reassigned for
    redirections
  * Move carriage return to the clear method
  * Add better inspection now that we can have a nil total
  * Add note about unknown progress to the changelog
  * Add notes to the README about displaying unknown progress
  * Fix missing throttle rate in README
  * Allow the progress bar to have an 'unknown' amount of progress
  * Add item to the changelog
  * Update the benchmark script
  * Add #log to progressbar for properly handling bar output when printing to
    the output IO
  * Add CHANGELOG
  * Rename all of the requires lines to be consistent with the new lib file
  * Remove depreciation code

Version v1.1.2 - August 11, 2013
================================================================================

  * Fix the 'negative argument' problem - Closes #47
  * Update a spec that was passing when it shouldn't have been and pend it until
    we can implement the fix
  * Upgrade rspec and fuubar
  * When dividing up the remainder of the length and determining how much space
    a completed bar should take up, round down so that the bar doesn't complete
    until 100%
  * Add tags file to gitignore

Version v1.1.1 - June 8, 2013
================================================================================

  * Fix file modes to be world readable
  * Filter out specs themselves from coverage report
  * Add tags file to gitignore
  * Simplify #with_progressables and #with_timers

Version v1.1.0 - May 29, 2013
================================================================================

  * Upgrade simplecov so it is resilient to mathn being loaded
  * fix progress format when core lib mathn is loaded
  * Rename throttle_period to throttle_rate
  * Set a default throttle_period of 100 times per second
  * Use the new precise #elapsed_seconds in the throttle component
  * Add #elapsed_seconds that gets a more precise value for the elapsed time
  * Rename #elapsed_seconds to #elapsed_whole_seconds
  * Add throttle_period documentation
  * Made throttle API resemble other components
  * Add throttle_period option to #create
  * Add throttle component
  * Use StringIO in the new spec so we don't get output to STDOUT
  * fix for the ruby_debug error, where debug defines a start method on kernel
    that is used erroneously by progressbar
  * spec that recreates the problem we're seeing with ruby-debug under jruby
  * fix terminal width crashing progressbar
  * Add failing test for terminal width crashing progress bar
  * Make sure we're using an up-to-date version of the JSON gem
  * Fix gemspec since Date.today is no longer supported
  * Update ruby-prof
  * Upgrade timecop
  * Upgrade simplecov
  * Upgrade rake
  * Make changes related to rspectacular
  * Install rspectacular
  * Remove guard
  * Rework gem manifest so that it only calls ls-files once
  * Replace .rvmrc with .ruby-version
  * Rework #length specs now that we have a more complex set of specifications
  * Fix overriding the progress bar length with an environment variable.
  * Fix the `rdoc_options` specification in the gemspec
  * Add Ruby Markdown code fencing to the README

Version v1.0.2 - October 7, 2012
================================================================================

  * Remove superfluous comment
  * The amount returned if the total is 0 should always be 100 (as in 100%) and
    not the DEFAULT_TOTAL. Even though they currently happen to be the same
    number.
  * return DEFAULT_TOTAL for percentage_completed of total is zero, fixing
    ZeroDivisionError
  * Use io/console where available.
  * Add tmux notifications to Guardfile
  * Bundler is not a development dependency
  * Hashes are not ordered and therefore when looking for the time mocking
    method, we weren't selecting the proper one. Switched to an Array instead.
  * Update development gems
  * Move ruby-prof into the Gemfile so it is only loaded when it's MRI Ruby
  * Add a script for benchmarking
  * Now that we're memoizing Format::Base#bar_molecules, just use it to
    calculate how many bar molecules are left
  * Limit the API of the Format.Base class by making #non_bar_molecules and
    #bar_molecules private
  * Move Formatter#process into Format::Base because it is much more concerned
    with the format
  * Remove the Kernel#tap in Formatter#process and just use an instance variable
    instead
  * Now that we're not reparsing the format string each time, we can save some
    cycles by memoizing the Format::Base#non_bar_molecules and #bar_molecules
  * When setting the format string, if it hasn't changed, we don't need to
    reparse it
  * Extract the logic of setting the format string out into its own private
    method ProgressBar::Formatter#format_string=
  * Add 'ruby-prof' to the project as a development gem

Version v1.0.1 - August 28, 2012
================================================================================

  * Add Ruby 1.8.7 back into Travis CI build
  * Fixing string slice bug
  * Add a Rakefile
  * Update .gitignore
  * Add Rake to the Gemfile

Version v1.0.0 - August 18, 2012
================================================================================

  * Remove 1.8 from the Ruby Travis builds
  * Add a spec for the %% molecule
  * Fix bug where a progress bar with an integrated percentage miscalculated the
    space it was taking up
  * fix @terminal_width and bar_width calculation
  * Fix more README typos
  * Set the default bar mark to '='
  * Make sure to blow up if a molecule is not value
  * It's not sufficient to say that a molecule is 'a percent sign followed by
    something that isn't a percent sign', we need to force it to be followed by a
    letter
  * Fix &nbsp; problems in the README
  * Update the formatting to make sure the %b and %i formatting molecules can
    coexist with each other
  * Now that we can use the %b and %i flags, we can create a mirrored bar simply
    by using a format string of '%i%b' and therefore this extra code is no longer
    necessary
  * Make sure that when the timer is started, then stopped, then started again,
    it should not register as `stopped?`
  * Allow %i to be used display the incomplete space of the bar
  * Update `ProgressBar::Formatter#format` to reset the bar style to default if
    it is called without passing in a format string
  * Allow the %b molecule to be used to display the bar only without incomplete
    space
  * Update the %B format test to be more reasonable
  * Make the %w molecule only return the bar with the percentage instead of
    including empty space
  * Remove the `length` argument when calling
    `ProgressBar::Components::Bar#to_s` and instead set the attribute
  * Rename `ProgressBar::Formatter#bar` to `#complete_bar`
  * Change the %b (bar with percentage) format molecule to %w
  * Swap the meaning of the %b and %B molecules
  * There was a typo in the example formats in the README. The literal percent
    sign needs to be included in the format string
  * Make sure the '%%' molecule is formatted properly
  * Little refactoring on the `ProgressBar::Formatter#process` method
  * README update
  * Remove all of the `ProgressBar::Base#update` calls and convert to method
    calls that take a block `#with_update`
  * Add an "In The Weeds" section to the README
  * Add 'It's better than some other library' section to the README
  * Add contributors to the README
  * Add supported Rubies to the README
  * Tons of README formatting updates
  * Add time-mocking information to the README
  * If Time is being mocked via Delorean, make sure that the progress bar always
    uses the unmocked time
  * If Time is being mocked via Timecop, make sure that the progress bar always
    uses the unmocked time
  * When testing, make sure that we're able to always get the proper version of
    `now` that we need for our particular spec
  * When calling `ProgressBar::Time.now` allow a Time-like object to be passed
    in
  * Add a `ruby-progressbar`-specific implementation of Time to encapsulate the
    business logic
  * Extract the notion of `now` into a method on the `Timer` module
  * Remove extra `private`
  * Use inheritance to put `title=` in the Formatter module where it belongs
  * I didn't notice that #total and #progress were available in the Formatter
    module
  * Move logic specific to the modules into those modules and use the
    inheritance chain to get at them
  * Evidently Travis is having issues with Rubinius so we'll remove them from
    our .travis.yml file to get a passing build
  * Try and get better 1.8.7 compatibility when checking the end character in
    the progressbar string
  * Add the Travis-CI build status to the README
  * Add the Travis-CI configuration file
  * Update the other deprecation warnings outside of `ProgressBar::Base`
  * Add the remaining method deprecation/warning messages
  * Use a little metaprogramming to further dry up the deprecation messages
  * fixup! c3e6991988107ab45ac3dac380750b287db3bc2e
  * When displaying deprecation warnings for methods, only show them one time;
    not every time the method is invoked
  * Dry up the warning messages in `ProgressBar::Depreciable`
  * Move `ProgressBar::Base#backwards_compatible_args_to_options_conversion` to
    the `ProgressBar::Depreciable` module
  * Add a new `ProgressBar::Depreciable` module to encapsulate all of the
    deprecation logic
  * Forgot to return the `options` hash from
    `ProgressBar::Base#backwards_compatible_args_to_options_conversion`
  * Add the old `bar_mark=` method back so it's more backwards compatible
  * Update deprecation warnings to expire June 30th, 2013 instead of October
    30th, 2013
  * Update the README to reflect the new syntax for creating a ProgressBar
  * Override `ProgressBar.new` and remain backward compatible with the pre-1.0
    versions of the gem
  * Convert the `ProgressBar` module to a class so that we can...
  * Add `ProgressBar::Base#progress` and `#total`
  * Update the gemspec
  * Update the `EstimatedTimer` specs when smoothing is turned off such that the
    `#decrement` spec is sufficiently different from the smoothing on `#decrement`
    spec
  * Update `EstimatedTimer` specs when smoothing is turned off to be more
    consistent with the new smoothing specs
  * Add `EstimatedTimer` specs to test when smoothing is turned on
  * Update the spec text for the `EstimatedTimer` class so that it doesn't
    contain the actual expected value but rather the general expectation
  * Extract `smoothing` into its own `let` variable
  * Add notes to the README about smoothing
  * Invert the smoothing value such that 0.0 is no smoothing and 1.0 is maximum
    smoothing
  * Set the default smoothing value to 0.9
  * Convert the `EstimatedTime#estimated_seconds_remaining` over to using the
    running average
  * Tell the `Progressable` module to update the running average any time the
    `progress` is set
  * Add the notion of a `smoothing` variable to the `Progressable` module for
    use when calculating the running average
  * Introduce `Progressable#running_average` and reset it any time
    `Progressable#start` is called
  * Add a RunningAverageCalculator so we can offload the logic for calculating
    running averages in our Progressables
  * Always refer to `total` using the accessor rather than the instance variable
  * Fix place where we were using a literal string for our time format rather
    than the TIME_FORMAT constant
  * Make the `Progressable` initializer optional
  * Fix README mistake regarding out of bounds ETAs
  * In Progressable, rather than accessing the starting_position instance
    variable, use an accessor
  * Rather than having the logic in multiple places, use `Progressable#start`
    where possible
  * Update the Progressable module to always reference the `progress` accessor
    rather than the instance variable
  * Add the ability to customize the bar's title in real time
  * Add a note to the README about customizing the bar in real time
  * Add notes to the README about overriding the bar's length
  * Update the deprecation date of
  * Upgrade the README to describe the new 'integrated percentage' formatting
    option
  * Update Ruby version in .rvmrc
  * Replace @out.print with @out.write to work better in dumb terminal like
    Emacs' M-x shell.
  * Document the smoothing attribute a little better.
  * Rewrote smoothing stuff to something better.
  * Offload handling of weird time values to format_time (isn't that its job?)
    ;-)
  * Added "smoothing" attribute (default 0.9). It can be set to nil to use the
    old ETA code.
  * Make time estimate a smoothed moving average
  * Use the inherited #initialize
  * Add a format where the bar has an integrated percentage
  * Just always run all specs
  * Alias stopped? to paused?
  * If the bar is completed, show the elapsed time, otherwise show the estimated
    time
  * estimated_time to estimated_time_with_no_oob
  * Add a Guardfile
  * Add the ability to set the progress mark at any point
  * Upgrade RSpec in the Gemfile
  * Allow :focused w/o the '=> true'
  * More gem updates. Include guard
  * Quotes
  * Unindent private methods
  * And again
  * Consistency is key
  * And again
  * Change to new date and repo
  * Upgraded RSpec uses RSpec not Rspec
  * Not sure why I did this here
  * Upgrade RSpec and SimpleCov
  * Bump Ruby version to 1.9.3
  * allow to customize the #title_width
  * Detect whether the output device is a terminal, and use a simplified output
    strategy when it is not.
  * Use 1.9 compatible require in test.
  * Add tests for Timecop and Delorean time mocking
  * Make Progressbar resistant to time mocking
  * Automatically tag gem builds as Date.today
  * Replace the Bar's instance variable references
  * Remove Options Parser
  * The starting value should be passed on #start
  * Remove Title class for now
  * Change 'reversed bar' to 'mirrored bar'
  * Rename `out` to `output` and access w/o variable
  * Change default output to STDOUT
  * Rename `output_stream` to `output`
  * Rename `current` to `progress`
  * Update README
  * Add #decrement to the progress bar
  * Backwards compatibility for instantiation
  * Create `with_timers` helper
  * Update spec_helper with new root gem file
  * Update gemspec with new license file
  * Update gemspec to auto-update Date
  * Add deprecation and backwards compatibility helprs
  * Add SimpleCov to the project
  * Rename 'beginning_position' option to 'started_at'
  * Fix require files
  * Update README
  * Update README
  * Update README
  * Remove Test::Unit test cases which are covered
  * Replace licenses with the MIT license
  * Begin updating README
  * Add .gitignore
  * Fix 'ArgumentError: negative argument' when using with Spork
  * Bar can be forcibly stopped
  * Autostart for now
  * Add ability to pause/resume progress bar
  * Bar resets the elapsed time when reset.
  * Bar resets the estimated time when reset.
  * Timers can now be reset
  * #start determines #reset position
  * On #reset, bar goes back to its starting position
  * Bar can be reset back to 0
  * Fix test typo
  * Fix tests
  * Reminder for autostart
  * Move #title
  * Delete unneeded code
  * Stop Elapsed Timer on finish
  * Progressable components finish properly
  * Refactor out common 'Progressable' functionality
  * Prepare for more 'finish' functionality
  * Refactor common Timer functionality into a module
  * Bar outputs a \n when it's finished
  * Bar can now be "finished"
  * Remove unnecessary (for now) code
  * Resizing algorithm is much smarter
  * Fix length_changed? check
  * Move formatting methods and make them private
  * Create #inspect method
  * Remove implemented methods
  * We have a LICENSE file. No need for this.
  * Fix output problem
  * Always show 2 decimal places with precise percentage
  * Elapsed Time works properly with progress bar
  * Estimated Timer works properly with progress bar
  * %r format string works properly
  * Estimated Timer can now be incremented
  * Bar graphic can now be reversed
  * Remove method arguments from molecule
  * %e, %E and %f format the estimated time correctly
  * Formatting
  * Include Molecule specs
  * Estimated Timer works with out of bounds times
  * Estimated Timer displays estimated time correctly
  * Estimated Timer displays unknown time remaining
  * Estimated Time can now be displayed
  * Make Timer work properly
  * Move bar_spec to the proper locale
  * Elapsed Time can now be displayed
  * Percentage information can now be displayed
  * Capacity information can now be displayed
  * Move Bar and Title into Components submodule
  * Base refactoring work laid out
  * Add RSpec support files
  * Create a Gemfile and other infrastructure files
  * Update gemspec
  * Fix to failing test: Adjusting the path to progressbar.rb file
  * accessor for alternate bar mark
  * Updated gem name to match project (so it would build)
  * Add a gemspec.
  * Move progressbar.rb into lib/.
  * Add LICENSE files.
  * Get rid of the ChangeLog. That's what revision logs are for.
  * Make the readme use Markdown.
  * Initial commit (based on Ruby/ProgressBar 0.9).

