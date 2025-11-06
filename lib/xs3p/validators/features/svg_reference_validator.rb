# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Features
      # Validates SVG diagram references in element documentation
      class SvgReferenceValidator < BaseValidator
        attr_reader :element_name

        def initialize(document, element_name)
          super(document)
          @element_name = element_name
        end

        def validate
          result = result("SVG Reference: #{element_name}")

          element = @document.find_element_by_name(element_name)
          if element.nil?
            result.add_error("Element '#{element_name}' not found")
            return result
          end

          validate_svg_object(element, result)

          result
        end

        private

        def validate_svg_object(element, result)
          svg_object = element.at_css('object[type="image/svg+xml"]')

          if svg_object.nil?
            result.add_warning(
              "SVG diagram object not found for element '#{element_name}'"
            )
            return
          end

          validate_svg_attributes(svg_object, result)
        end

        def validate_svg_attributes(svg_object, result)
          data_attr = svg_object["data"]

          if data_attr.nil? || data_attr.empty?
            result.add_error("SVG object missing 'data' attribute")
            return
          end

          unless data_attr.include?(".svg")
            result.add_warning(
              "SVG object 'data' attribute does not reference .svg file"
            )
          end

          if data_attr.include?("diagrams/")
            expected_path = "diagrams/#{element_name}.svg"
            unless data_attr.include?(expected_path)
              result.add_warning(
                "SVG path is '#{data_attr}', expected to include " \
                "'#{expected_path}'"
              )
            end
          end
        end
      end
    end
  end
end