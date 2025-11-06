# frozen_string_literal: true

require_relative "../table_validator"

module Xs3p
  module Validators
    module Content
      # Validates component properties tables
      class PropertiesTableValidator < TableValidator
        attr_reader :component_name

        def initialize(document, component_element, component_name)
          @component_name = component_name
          super(document, component_element)
        end

        protected

        def validate_table_content(result)
          return if @table.nil?

          validate_table_has_rows(result)
          validate_property_rows(result)
        end

        private

        def validate_table_has_rows(result)
          rows = table_rows
          if rows.empty?
            result.add_error(
              "Properties table for '#{component_name}' has no rows"
            )
          end
        end

        def validate_property_rows(result)
          rows = table_rows

          rows.each_with_index do |row, index|
            validate_row_structure(row, index, result)
          end
        end

        def validate_row_structure(row, index, result)
          cells = row.css("td, th")

          if cells.size < 2
            result.add_warning(
              "Properties table row #{index + 1} has fewer than 2 cells"
            )
            return
          end

          property_name = cells[0].text.strip
          if property_name.empty?
            result.add_warning(
              "Properties table row #{index + 1} has empty property name"
            )
          end
        end
      end
    end
  end
end