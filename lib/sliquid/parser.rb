module Sliquid
  class Parser < Slim::Parser
    set_default_options :attr_list_delims => {
      '(' => ')',
      '[' => ']'
    }

    def unknown_line_indicator
      case @line
      when /\A%\s*(\w+)/
        @line = $'
        parse_liquid_tag($1)
      when /\A\{/
        block = [:multi]
        @stacks.last << [:multi, [:slim, :interpolate, @line], block]
        @stacks << block
      else
        super
      end
    end

    def parse_liquid_tag(name)
      block = [:multi]
      @stacks.last << [:liquid, :tag, name, @line.strip, block]
      @stacks << block
    end
  end
end
