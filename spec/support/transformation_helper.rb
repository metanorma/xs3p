# frozen_string_literal: true

module TransformationHelper
  def transform_xsd(fixture_name, parameters: {})
    transformer = Xs3p::Transformer.new
    fixture_manager = Xs3p::TestFixtureManager.new

    xsd_path = fixture_manager.fixture_path(fixture_name)
    nokogiri_doc = transformer.transform_file(xsd_path, parameters: parameters)

    Xs3p::HtmlDocument.new(nokogiri_doc)
  end

  def transform_xsd_string(xsd_content, parameters: {})
    transformer = Xs3p::Transformer.new
    nokogiri_doc = transformer.transform(xsd_content, parameters: parameters)

    Xs3p::HtmlDocument.new(nokogiri_doc)
  end
end

RSpec.configure do |config|
  config.include TransformationHelper
end