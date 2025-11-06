# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Document
      # Validates HTML head section (meta, title, CSS/JS links)
      class HeadSectionValidator < BaseValidator
        def validate
          result = result("Head Section")

          head = @document.head_section
          if head.nil?
            result.add_error("Head section not found")
            return result
          end

          validate_meta_charset(head, result)
          validate_title(head, result)
          validate_bootstrap_css(result)
          validate_jquery(result)
          validate_bootstrap_js(result)

          result
        end

        private

        def validate_meta_charset(head, result)
          meta_charset = head.at_css('meta[charset]')

          if meta_charset.nil?
            result.add_error("Meta charset declaration missing")
            return
          end

          charset = meta_charset["charset"]
          if charset.upcase != "UTF-8"
            result.add_warning(
              "Meta charset is '#{charset}', recommended 'UTF-8'"
            )
          end
        end

        def validate_title(head, result)
          title = head.at_css("title")

          if title.nil?
            result.add_error("Document title missing")
          elsif title.text.strip.empty?
            result.add_error("Document title is empty")
          end
        end

        def validate_bootstrap_css(result)
          css_includes = @document.css_includes

          unless css_includes.any? { |href| href.include?("bootstrap") && href.include?(".css") }
            result.add_error("Bootstrap CSS not included")
          end
        end

        def validate_jquery(result)
          js_includes = @document.js_includes

          unless js_includes.any? { |src| src.include?("jquery") }
            result.add_error("jQuery not included")
          end
        end

        def validate_bootstrap_js(result)
          js_includes = @document.js_includes

          unless js_includes.any? { |src| src.include?("bootstrap") && src.include?(".js") }
            result.add_error("Bootstrap JavaScript not included")
          end
        end
      end
    end
  end
end