# frozen_string_literal: true

require_relative "../section_validator"

module Xs3p
  module Validators
    module Components
      # Validates complex type section
      class ComplexTypeSectionValidator < SectionValidator
        def initialize(document)
          super(document, "SectionSchemaComplexTypes")
        end

        protected

        def validate_section_structure(section, result)
          validate_section_heading(section, "Complex Types", result)
          validate_anchor_present(section, result)
        end

        def validate_section_content(section, result)
          types = section.css("[id^='type_']")

          if types.empty?
            result.add_warning(
              "No complex type documentation found in section"
            )
            return
          end

          validate_type_components(types, result)
        end

        private

        def validate_type_components(types, result)
          types.each do |type|
            type_id = type["id"]
            type_name = type_id.sub(/^type_/, "")

            validate_type_structure(type, type_name, result)
          end
        end

        def validate_type_structure(type, name, result)
          heading = type.at_css("h3, h4")
          if heading.nil?
            result.add_warning(
              "Complex type '#{name}': heading not found"
            )
          end

          validate_type_content(type, name, result)
        end

        def validate_type_content(type, name, result)
          table = type.at_css("table")
          if table.nil?
            result.add_warning(
              "Complex type '#{name}': properties table not found"
            )
          end
        end
      end
    end
  end
end