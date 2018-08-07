module Jekyll
  module Convertible
    def render_liquid_with_transform(content, payload, info, path = nil)
      content = pretransform(content)
      render_liquid_without_transform(content, payload, info, path)
    end

    alias_method :render_liquid_without_transform, :render_liquid
    alias_method :render_liquid, :render_liquid_with_transform

    def converters_without_preconverters
      converters_with_preconverters.reject { |c| c.is_a? Jekyll::Slim::Converter }
    end

    alias_method :converters_with_preconverters, :converters
    alias_method :converters, :converters_without_preconverters

    def preconverters
      converters_with_preconverters.select { |c| c.is_a? Jekyll::Slim::Converter }
    end

    def pretransform(content)
      preconverters.reduce(content) do |output, converter|
        begin
          converter.convert output
        rescue => e
          Jekyll.logger.error "Conversion error:", "#{converter.class} encountered an error while preconverting '#{path}':"
          Jekyll.logger.error("", e.to_s)
          raise e
        end
      end
    end

    def output_ext_with_preconverters
      if preconverters.all? { |c| c.is_a?(Jekyll::Converters::Identity) }
        output_ext_without_preconverters
      else
        preconverters.map do |c|
          c.output_ext(ext) unless c.is_a?(Jekyll::Converters::Identity)
        end.compact.last
      end
    end

    alias_method :output_ext_without_preconverters, :output_ext
    alias_method :output_ext, :output_ext_with_preconverters
  end

  class Layout
    def initialize_with_pretransform(*args)
      initialize_without_pretransform(*args)
      self.content = pretransform(content)
    end

    alias_method :initialize_without_pretransform, :initialize
    alias_method :initialize, :initialize_with_pretransform
    alias_method :extname, :ext
  end
end
