Changelog
================================================================================

v1.5.0
--------------------------------------------------------------------------------
* Official Ruby 2.x support
* Add '%r' and '%R' which will display the rate per second
* Add a `rate_scale` option when creating the bar which adjusts the rate in
  realtime

v1.4.2
--------------------------------------------------------------------------------
* Fix ETA when progress happens very quickly - c/o @marcandre

v1.4.1
--------------------------------------------------------------------------------
* Use Kernel.warn instead of STDOUT.puts so that warnings can be suppressed
  globally
* Fix problem where progress bar would error if it was stopped while it was
  already stopped. - c/o @jdelStrother

v1.4.0
--------------------------------------------------------------------------------
* Add `#started?`
* Timers are now explicitly stopped when the bar is stopped
* Bar now outputs a warning if a paused bar has its progress changed
* Any changes to the bar total now refreshes the bar
* Fix problem where the bar would blow up if the total was nil

v1.3.2
--------------------------------------------------------------------------------
* Testing fixes

v1.3.1
--------------------------------------------------------------------------------
* Fix problem where the bar would blow up if the throttle rate was passed in as
  nil.

v1.3.0
--------------------------------------------------------------------------------
* Improved output for non-TTY streams. Incremental output is not enabled.
* Added an `autostart` option.  It defaults to `true`.  If set to `false`,
  `#start` must explicitly be called.
* The bar will no longer output multiple times if `#finish` is called when the
  bar is already finished.  Same thing with `#stop`, `#resume`, `#pause`, etc.
* Added `#remainder_mark` which will allow the user to set the character(s),
  shown on the incomplete portion of the bar.
* Enabled ANSI color codes to be used in the bar format and still have the bar
  length properly represented.

v1.2.0
--------------------------------------------------------------------------------
* Finally removed deprecation warning and made folder structure consistent
* Add #log which will properly handle the display of the bar when sending
  a string of output to the screen.
* Add unknown progress. See the README for more details.
* Add proper output for non-TTY IO streams
