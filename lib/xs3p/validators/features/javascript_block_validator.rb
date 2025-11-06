# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Features
      # Validates embedded and linked JavaScript
      class JavascriptBlockValidator < BaseValidator
        def validate
          result = result("JavaScript")

          validate_jquery_present(result)
          validate_bootstrap_js_present(result)
          validate_markdown_converter(result)

          result
        end

        private

        def validate_jquery_present(result)
          unless @document.jquery_present?
            result.add_error("jQuery not included")
          end
        end

        def validate_bootstrap_js_present(result)
          unless @document.bootstrap_js_present?
            result.add_error("Bootstrap JavaScript not included")
          end
        end

        def validate_markdown_converter(result)
          scripts = @document.css("script")
          markdown_found = scripts.any? do |script|
            script.text.include?("Markdown.Converter") ||
              script["src"]&.include?("markdown")
          end

          unless markdown_found
            result.add_warning(
              "Markdown.Converter not found in JavaScript"
            )
          end
        end
      end
    end
  end
end