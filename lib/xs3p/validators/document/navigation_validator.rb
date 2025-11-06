# frozen_string_literal: true

require_relative "../base_validator"

module Xs3p
  module Validators
    module Document
      # Validates navigation/TOC sidebar structure
      class NavigationValidator < BaseValidator
        def validate
          result = result("Navigation")

          nav = @document.navigation_section
          if nav.nil?
            result.add_error("Navigation section not found")
            return result
          end

          validate_nav_structure(nav, result)
          validate_nav_links(nav, result)

          result
        end

        private

        def validate_nav_structure(nav, result)
          nav_list = nav.at_css("ul.nav.nav-list, ul.xs3p-sidenav")

          if nav_list.nil?
            result.add_error(
              "Navigation list with class 'nav nav-list' or 'xs3p-sidenav' " \
              "not found"
            )
            return
          end

          validate_nav_items(nav_list, result)
        end

        def validate_nav_items(nav_list, result)
          items = nav_list.css("li")

          if items.empty?
            result.add_warning("Navigation has no items")
          end
        end

        def validate_nav_links(nav, result)
          links = nav.css("a[href]")

          if links.empty?
            result.add_error("Navigation has no links")
            return
          end

          validate_schema_properties_link(links, result)
          validate_component_section_links(links, result)
        end

        def validate_schema_properties_link(links, result)
          schema_props_link = links.find do |link|
            href = link["href"]
            href&.include?("SchemaProperties")
          end

          if schema_props_link.nil?
            result.add_warning("Schema Properties link not found in navigation")
          end
        end

        def validate_component_section_links(links, result)
          expected_sections = %w[
            Elements
            ComplexTypes
            SimpleTypes
            Attributes
            Groups
          ]

          expected_sections.each do |section|
            section_link = links.find do |link|
              link.text.include?(section) || link["href"]&.include?(section)
            end

            if section_link.nil?
              result.add_warning(
                "Navigation link for '#{section}' not found"
              )
            end
          end
        end
      end
    end
  end
end