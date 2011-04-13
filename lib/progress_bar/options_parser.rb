module ProgressBar
  module OptionsParser
    private
      def title_options_from(options)
        options.select {|k,v| Components::Title::OPTIONS.include? k}
      end

      def bar_options_from(options)
        options.select {|k,v| Components::Bar::OPTIONS.include? k}
      end
  end
end
