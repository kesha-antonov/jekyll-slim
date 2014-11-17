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
  end
end
