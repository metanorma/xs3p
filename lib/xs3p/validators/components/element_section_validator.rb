# frozen_string_literal: true

require_relative "../section_validator"

module Xs3p
  module Validators
    module Components
      # Validates element declarations section
      class ElementSectionValidator < SectionValidator
        def initialize(document)
          super(document, "SectionSchemaElements")
        end

        protected

        def validate_section_structure(section, result)
          validate_section_heading(section, "Elements", result)
          validate_anchor_present(section, result)
        end

        def validate_section_content(section, result)
          elements = section.css("[id^='element_']")

          if elements.empty?
            result.add_warning("No element documentation found in section")
            return
          end

          validate_element_components(elements, result)
        end

        private

        def validate_element_components(elements, result)
          elements.each do |element|
            element_id = element["id"]
            element_name = element_id.sub(/^element_/, "")

            validate_element_structure(element, element_name, result)
          end
        end

        def validate_element_structure(element, name, result)
          heading = element.at_css("h3, h4")
          if heading.nil?
            result.add_warning(
              "Element '#{name}': heading not found"
            )
          end

          validate_element_sections(element, name, result)
        end

        def validate_element_sections(element, name, result)
          validate_properties_table_present(element, name, result)
          validate_instance_representation_present(element, name, result)
          validate_schema_representation_present(element, name, result)
        end

        def validate_properties_table_present(element, name, result)
          table = element.at_css("table")
          if table.nil?
            result.add_warning(
              "Element '#{name}': properties table not found"
            )
          end
        end

        def validate_instance_representation_present(element, name, result)
          instance_section = find_representation_section(
            element,
            "XML Instance Representation"
          )

          if instance_section
            validate_code_block(instance_section, name, "instance", result)
          end
        end

        def validate_schema_representation_present(element, name, result)
          schema_section = find_representation_section(
            element,
            "Schema Component Representation"
          )

          if schema_section
            validate_code_block(schema_section, name, "schema", result)
          end
        end

        def find_representation_section(element, heading_text)
          headings = element.css("h4, h5, h6")
          headings.find { |h| h.text.include?(heading_text) }
        end

        def validate_code_block(heading, name, type, result)
          code_block = heading.at_xpath("following-sibling::pre")

          if code_block.nil?
            result.add_warning(
              "Element '#{name}': #{type} representation code block not found"
            )
          elsif !code_block["class"]&.include?("codehilite")
            result.add_warning(
              "Element '#{name}': #{type} code block missing " \
              "'codehilite' class"
            )
          end
        end
      end
    end
  end
end