# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Features
      # Validates CSS styles and syntax highlighting classes
      class CssStyleValidator < BaseValidator
        def validate
          result = result("CSS Styles")

          validate_syntax_highlighting_classes(result)
          validate_bootstrap_css_present(result)

          result
        end

        private

        def validate_syntax_highlighting_classes(result)
          code_blocks = @document.css("pre.codehilite")

          if code_blocks.empty?
            result.add_warning(
              "No code blocks with 'codehilite' class found"
            )
            return
          end

          validate_highlight_class_usage(code_blocks, result)
        end

        def validate_highlight_class_usage(code_blocks, result)
          expected_classes = %w[nt na s c cs]
          found_classes = []

          code_blocks.each do |block|
            expected_classes.each do |cls|
              if block.css(".#{cls}").any?
                found_classes << cls
              end
            end
          end

          found_classes.uniq!

          if found_classes.empty?
            result.add_warning(
              "No syntax highlighting classes found in code blocks"
            )
          end
        end

        def validate_bootstrap_css_present(result)
          unless @document.bootstrap_css_present?
            result.add_error("Bootstrap CSS not included")
          end
        end
      end
    end
  end
end