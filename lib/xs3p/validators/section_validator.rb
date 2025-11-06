# frozen_string_literal: true

require_relative "base_validator"

module Xs3p
  module Validators
    # Base validator for document sections
    class SectionValidator < BaseValidator
      attr_reader :section_id

      def initialize(document, section_id)
        super(document)
        @section_id = section_id
      end

      def validate
        result = result("Section: #{section_id}")
        section = @document.component_section(section_id)

        if section.nil?
          result.add_error("Section '##{section_id}' not found")
          return result
        end

        validate_section_structure(section, result)
        validate_section_content(section, result)

        result
      end

      protected

      def validate_section_structure(section, result)
        # Override in subclasses
      end

      def validate_section_content(section, result)
        # Override in subclasses
      end

      def find_section_heading(section)
        section.at_css("h2, h3, h4")
      end

      def validate_section_heading(section, expected_text, result)
        heading = find_section_heading(section)

        if heading.nil?
          result.add_error("Section heading not found")
        elsif expected_text && !heading.text.include?(expected_text)
          result.add_warning(
            "Section heading '#{heading.text}' does not match " \
            "expected '#{expected_text}'"
          )
        end
      end

      def validate_anchor_present(section, result)
        anchor = section.at_css("a[id]")
        if anchor.nil?
          result.add_warning("Section anchor not found")
        end
      end
    end
  end
end