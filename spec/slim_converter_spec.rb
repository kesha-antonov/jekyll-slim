require 'spec_helper'

describe(Jekyll::Slim::Converter) do
  let(:configuration) { Jekyll::Configuration::DEFAULTS }
  let(:converter) do
    Jekyll::Slim::Converter.new(configuration)
  end

  let(:input) do
    <<-EOS
  h1 Hello
  .foo
EOS
  end

  let(:output) do
    '<h1>Hello</h1><div class="foo"></div>'
  end

  describe "file extensions" do
    it "matches .slim" do
      expect(converter.matches(".slim")).to be(true)
    end

    it "outputs .html files" do
      expect(converter.output_ext(".blablabl")).to eql(".html")
    end
  end

  describe "#convert" do
    it "outputs correct HTML" do
      expect(converter.convert(input)).to eql(output)
    end
  end
end
