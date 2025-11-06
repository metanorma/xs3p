# frozen_string_literal: true

require_relative "base_validator"

module Xs3p
  module Validators
    # Base validator for schema components (elements, types, etc.)
    class ComponentValidator < BaseValidator
      attr_reader :component_name, :component_type

      def initialize(document, component_name, component_type)
        super(document)
        @component_name = component_name
        @component_type = component_type
      end

      def validate
        result = result("#{component_type}: #{component_name}")
        component = find_component

        if component.nil?
          result.add_error("Component not found")
          return result
        end

        validate_component_id(component, result)
        validate_component_heading(component, result)
        validate_component_content(component, result)

        result
      end

      protected

      def find_component
        case component_type
        when :element
          @document.find_element_by_name(component_name)
        when :type
          @document.find_type_by_name(component_name)
        when :attribute
          @document.find_attribute_by_name(component_name)
        when :group
          @document.find_group_by_name(component_name)
        when :attribute_group
          @document.find_attribute_group_by_name(component_name)
        when :notation
          @document.find_notation_by_name(component_name)
        end
      end

      def expected_component_id
        "#{component_type}_#{component_name}"
      end

      def validate_component_id(component, result)
        actual_id = component["id"]
        expected_id = expected_component_id

        if actual_id != expected_id
          result.add_error(
            "Component ID is '#{actual_id}', expected '#{expected_id}'"
          )
        end
      end

      def validate_component_heading(component, result)
        heading = component.at_css("h3, h4")
        if heading.nil?
          result.add_error("Component heading not found")
        end
      end

      def validate_component_content(component, result)
        # Override in subclasses for specific component validations
      end

      def validate_properties_table(component, result)
        table = component.at_css("table")
        if table.nil?
          result.add_warning("Properties table not found")
          return
        end

        validate_table_structure(table, result)
      end

      def validate_table_structure(table, result)
        rows = table.css("tr")
        if rows.empty?
          result.add_error("Properties table has no rows")
        end
      end
    end
  end
end