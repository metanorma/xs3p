# frozen_string_literal: true

require "nokogiri"

module Xs3p
  # Executes XSL transformations using Nokogiri
  class Transformer
    attr_reader :xsl_path, :xsl_stylesheet

    DEFAULT_XSL_PATH = File.expand_path(
      "../../../xsl/xs3p.xsl",
      __FILE__
    )

    def initialize(xsl_path: DEFAULT_XSL_PATH)
      @xsl_path = xsl_path
      load_stylesheet
    end

    def transform(xsd_input, parameters: {})
      xsd_doc = parse_xsd_input(xsd_input)
      transformed = apply_transformation(xsd_doc, parameters)
      Nokogiri::HTML(transformed.to_s)
    end

    def transform_file(xsd_file_path, parameters: {})
      transform(File.read(xsd_file_path), parameters: parameters)
    end

    private

    def load_stylesheet
      xsl_content = File.read(@xsl_path)
      @xsl_stylesheet = Nokogiri::XSLT.parse(xsl_content)
    end

    def parse_xsd_input(xsd_input)
      case xsd_input
      when String
        Nokogiri::XML(xsd_input)
      when Nokogiri::XML::Document
        xsd_input
      else
        raise ArgumentError, "XSD input must be String or Nokogiri::XML::Document"
      end
    end

    def apply_transformation(xsd_doc, parameters)
      xslt_params = build_xslt_parameters(parameters)
      @xsl_stylesheet.transform(xsd_doc, xslt_params)
    end

    def build_xslt_parameters(parameters)
      xslt_params = []
      parameters.each do |key, value|
        xslt_params << key.to_s
        xslt_params << quote_parameter_value(value)
      end
      xslt_params
    end

    def quote_parameter_value(value)
      case value
      when true, false
        "'#{value}'"
      when String
        "'#{value}'"
      else
        "'#{value}'"
      end
    end
  end
end