module ProgressBar
  class Title
    OPTIONS                   = [:title, :title_length]

    DEFAULT_TITLE             = 'Progress'

    attr_reader               :text

    def initialize(options = {})
      @text                   = options[:title]         || DEFAULT_TITLE
      @length_override        = options[:title_length]
    end

    def to_s
      text
    end

    # private
      # def visible_text
        # text.slice(0, visible_text_length)
      # end

      # def visible_text_length
        # @length_override || text.length
      # end
  end
end
