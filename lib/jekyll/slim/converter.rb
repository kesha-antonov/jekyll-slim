module Jekyll
  module Slim
    class Converter < ::Jekyll::Converter
      safe false
      priority :low

      def matches(ext)
        ext.downcase == '.slim'
      end

      def output_ext(ext)
        '.html'
      end

      def convert(content)
        self.class.convert(@config, content)
      end

      def self.convert(config, content)
        config = config['slim'] || {}
        ::Sliquid::Converter.new(config) { content }.render(Object.new)
      end
    end
  end
end
