# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Content
      # Validates XML instance representation blocks
      class InstanceRepresentationValidator < BaseValidator
        attr_reader :component_element, :component_name

        def initialize(document, component_element, component_name)
          super(document)
          @component_element = component_element
          @component_name = component_name
        end

        def validate
          result = result("Instance Representation: #{component_name}")

          heading = find_instance_heading
          if heading.nil?
            result.add_warning(
              "XML Instance Representation section not found"
            )
            return result
          end

          validate_code_block(heading, result)

          result
        end

        private

        def find_instance_heading
          headings = @component_element.css("h4, h5, h6")
          headings.find do |h|
            h.text.include?("XML Instance Representation")
          end
        end

        def validate_code_block(heading, result)
          code_block = heading.at_xpath("following-sibling::pre[1]")

          if code_block.nil?
            result.add_error("Code block not found after heading")
            return
          end

          validate_code_block_classes(code_block, result)
          validate_code_block_content(code_block, result)
        end

        def validate_code_block_classes(code_block, result)
          classes = code_block["class"]&.split || []

          unless classes.include?("codehilite")
            result.add_warning(
              "Code block missing 'codehilite' class for syntax highlighting"
            )
          end
        end

        def validate_code_block_content(code_block, result)
          content = code_block.text.strip

          if content.empty?
            result.add_error("Code block is empty")
          end
        end
      end
    end
  end
end