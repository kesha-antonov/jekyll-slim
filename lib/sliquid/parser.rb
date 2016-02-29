module Sliquid
  class Parser < Slim::Parser
    set_options :attr_list_delims => {
      '(' => ')',
      '[' => ']'
    }

    def unknown_line_indicator
      case @line
      when /\A%\s*(.+)/
        @line = $1
        parse_liquid_tag
      when /\A\{/
        block = [:multi]
        @stacks.last << [:multi, [:slim, :interpolate, @line], block]
        @stacks << block
      else
        super
      end
    end

    def parse_liquid_tag
      block = [:multi]
      @stacks.last << [:liquid, :tag, @line.strip, block]
      @stacks << block
    end
  end
end
