Changelog
================================================================================

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
