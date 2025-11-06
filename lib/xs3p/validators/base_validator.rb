# frozen_string_literal: true

require_relative "../validation_result"

module Xs3p
  module Validators
    # Abstract base validator with common validation helpers
    class BaseValidator
      attr_reader :document

      def initialize(document)
        @document = document
      end

      def validate
        raise NotImplementedError, "Subclasses must implement validate method"
      end

      protected

      def result(context = nil)
        ValidationResult.new(context || self.class.name)
      end

      def element_exists?(selector)
        !@document.at_css(selector).nil?
      end

      def element_missing?(selector)
        @document.at_css(selector).nil?
      end

      def has_class?(element, class_name)
        return false if element.nil?

        element["class"]&.split&.include?(class_name)
      end

      def has_attribute?(element, attr_name)
        return false if element.nil?

        !element[attr_name].nil?
      end

      def text_present?(element, expected_text = nil)
        return false if element.nil?

        text = element.text.strip
        return !text.empty? if expected_text.nil?

        text.include?(expected_text)
      end

      def count_elements(selector)
        @document.css(selector).size
      end

      def validate_required_element(selector, name, result)
        if element_missing?(selector)
          result.add_error("Required element missing: #{name} (#{selector})")
        end
      end

      def validate_element_attribute(element, attr_name, expected_value, result)
        return if element.nil?

        actual_value = element[attr_name]
        if actual_value.nil?
          result.add_error("Missing attribute '#{attr_name}' on element")
        elsif expected_value && actual_value != expected_value
          result.add_error(
            "Attribute '#{attr_name}' has value '#{actual_value}', " \
            "expected '#{expected_value}'"
          )
        end
      end

      def validate_element_class(element, class_name, result)
        return if element.nil?
        return if has_class?(element, class_name)

        result.add_error(
          "Element does not have expected class '#{class_name}'"
        )
      end

      def validate_non_empty_text(element, name, result)
        return if element.nil?

        if element.text.strip.empty?
          result.add_error("Element '#{name}' has no text content")
        end
      end
    end
  end
end