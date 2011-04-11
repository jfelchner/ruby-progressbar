module ProgressBar
  module OptionsParser
    private
      def title_options_from(options)
        options.select {|k,v| ProgressBar::Title::OPTIONS.include? k}
      end

      def bar_options_from(options)
        options[:length] = bar_length
        options.select {|k,v| ProgressBar::Bar::OPTIONS.include? k}
      end
  end
end
