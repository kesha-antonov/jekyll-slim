module Sliquid
  class Interpolation < Slim::Interpolation
    def on_slim_attrvalue(escape, code)
      if code =~ /\A\{\{.*\}\}\Z/
        [:static, code]
      else
        [:slim, :attrvalue, escape, code]
      end
    end

    def on_slim_interpolate(string)
      block = [:multi]
      begin
        case string
        when /\A\{/
          string, code = parse_expression($')
          block << [:escape, false, [:slim, :interpolate, "{#{code}}"]]
        when /\A([^\{]*)/
          block << [:slim, :interpolate, $&]
          string = $'
        end
      end until string.empty?
      block
    end

    protected

      def parse_expression(string)
        count, i = 1, 0
        while i < string.size && count != 0
          if string[i] == ?{
            count += 1
          elsif string[i] == ?}
            count -= 1
          end
          i += 1
        end

        raise(Temple::FilterError, "Text interpolation: Expected closing }") if count != 0

        return string[i..-1], string[0, i-1]
      end

  end
end
