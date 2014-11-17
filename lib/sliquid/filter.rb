module Sliquid
  class Filter < Slim::Filter
    def on_liquid_tag(expression, block)
      result = [:static, "{% #{expression} %}"]
      result = [:multi, result, compile(block)] unless empty_exp?(block)
      result
    end
  end
end
