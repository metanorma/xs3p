# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Document
      # Validates HTML5 document structure and DOCTYPE
      class DocumentStructureValidator < BaseValidator
        def validate
          result = result("Document Structure")

          validate_doctype(result)
          validate_html_element(result)
          validate_head_element(result)
          validate_body_element(result)

          result
        end

        private

        def validate_doctype(result)
          doctype = @document.doctype

          if doctype.nil?
            result.add_error("DOCTYPE declaration missing")
          elsif doctype.downcase != "html"
            result.add_error(
              "DOCTYPE is '#{doctype}', expected 'html' for HTML5"
            )
          end
        end

        def validate_html_element(result)
          html = @document.doc.at_css("html")

          if html.nil?
            result.add_error("Root <html> element missing")
            return
          end

          validate_html_attributes(html, result)
        end

        def validate_html_attributes(html, result)
          lang = html["lang"]
          if lang.nil? || lang.empty?
            result.add_warning(
              "HTML element missing 'lang' attribute for accessibility"
            )
          end
        end

        def validate_head_element(result)
          head = @document.head_section

          if head.nil?
            result.add_error("<head> element missing")
          end
        end

        def validate_body_element(result)
          body = @document.body_section

          if body.nil?
            result.add_error("<body> element missing")
          end
        end
      end
    end
  end
end