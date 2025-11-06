# frozen_string_literal: true

require_relative "base_validator"

module Xs3p
  module Validators
    # Base validator for HTML tables
    class TableValidator < BaseValidator
      attr_reader :table

      def initialize(document, table_selector)
        super(document)
        @table = find_table(table_selector)
      end

      def validate
        result = result("Table: #{table.nil? ? 'not found' : 'found'}")

        if @table.nil?
          result.add_error("Table not found")
          return result
        end

        validate_table_structure(result)
        validate_table_content(result)

        result
      end

      protected

      def find_table(selector)
        element = @document.at_css(selector)
        return nil if element.nil?

        element.name == "table" ? element : element.at_css("table")
      end

      def validate_table_structure(result)
        validate_table_rows(result)
      end

      def validate_table_content(result)
        # Override in subclasses
      end

      def validate_table_rows(result)
        rows = @table.css("tr")
        if rows.empty?
          result.add_error("Table has no rows")
        end
      end

      def table_headers
        @table.css("thead th, tr:first-child th").map(&:text).map(&:strip)
      end

      def table_rows
        @table.css("tbody tr, tr")
      end

      def validate_column_count(expected_count, result)
        rows = table_rows
        return if rows.empty?

        rows.each_with_index do |row, index|
          cells = row.css("td, th")
          actual_count = cells.size

          if actual_count != expected_count
            result.add_error(
              "Row #{index + 1} has #{actual_count} columns, " \
              "expected #{expected_count}"
            )
          end
        end
      end

      def validate_header_present(expected_headers, result)
        actual_headers = table_headers

        expected_headers.each do |expected|
          unless actual_headers.any? { |h| h.include?(expected) }
            result.add_error("Expected header '#{expected}' not found")
          end
        end
      end
    end
  end
end