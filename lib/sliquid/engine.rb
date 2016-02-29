module Sliquid
  class Engine < Slim::Engine
    replace Slim::Parser, Parser
    # , :file, :tabsize, :shortcut, :default_tag, :attr_delims, :attr_list_delims, :code_attr_delims
    before Slim::Interpolation, Interpolation
    after Parser, Filter
  end

  Converter = Temple::Templates::Tilt(Engine)

  class Template < Tilt::Template
    def prepare
      @converter = Converter.new(options) { data }
    end

    def evaluate(scope, locals, &block)
      liquid = @converter.render(scope, locals, &block)
      Tilt::LiquidTemplate.new(options) { liquid }.render(scope, locals, &block)
    end
  end
end

# Tilt.register(Sliquid::Template, 'sliquid')
