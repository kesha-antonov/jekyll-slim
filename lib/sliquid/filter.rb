module Sliquid
  class Filter < Slim::Filter
    def on_liquid_tag(name, args, block)
      result = [:static, "{% #{name} #{args} %}"]
      result = [:multi, result, block] unless empty_exp?(block)
      result
    end
  end
end
