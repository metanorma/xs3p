# frozen_string_literal: true

require_relative "../section_validator"

module Xs3p
  module Validators
    module Document
      # Validates schema properties section
      class SchemaPropertiesValidator < SectionValidator
        def initialize(document)
          super(document, "SectionSchemaProperties")
        end

        protected

        def validate_section_structure(section, result)
          validate_section_heading(section, "Schema Properties", result)
          validate_anchor_present(section, result)
        end

        def validate_section_content(section, result)
          validate_target_namespace(section, result)
          validate_namespace_table(section, result)
        end

        private

        def validate_target_namespace(section, result)
          target_ns = section.at_css("span.targetNS")

          if target_ns.nil?
            result.add_warning(
              "Target namespace span with class 'targetNS' not found"
            )
          end
        end

        def validate_namespace_table(section, result)
          table = section.at_css("table")

          if table.nil?
            result.add_warning("Namespace table not found")
            return
          end

          validate_table_headers(table, result)
          validate_table_content(table, result)
        end

        def validate_table_headers(table, result)
          headers = table.css("thead th, tr:first-child th")
            .map { |th| th.text.strip }

          expected_headers = ["Prefix", "Namespace"]

          expected_headers.each do |expected|
            unless headers.any? { |h| h.include?(expected) }
              result.add_warning(
                "Expected column header '#{expected}' not found in " \
                "namespace table"
              )
            end
          end
        end

        def validate_table_content(table, result)
          rows = table.css("tbody tr, tr")
            .reject { |tr| tr.css("th").any? }

          if rows.empty?
            result.add_warning(
              "Namespace table has no data rows"
            )
          end
        end
      end
    end
  end
end