# frozen_string_literal: true

module Xs3p
  # Wraps Nokogiri HTML document with semantic queries
  class HtmlDocument
    attr_reader :doc

    def initialize(nokogiri_doc)
      @doc = nokogiri_doc
    end

    def css(selector)
      @doc.css(selector)
    end

    def xpath(query)
      @doc.xpath(query)
    end

    def at_css(selector)
      @doc.at_css(selector)
    end

    def at_xpath(query)
      @doc.at_xpath(query)
    end

    def head_section
      at_css("head")
    end

    def body_section
      at_css("body")
    end

    def navigation_section
      at_css("nav")
    end

    def component_section(id)
      at_css("##{id}")
    end

    def glossary_section
      at_css("#SectionGlossary")
    end

    def schema_properties_section
      at_css("#SectionSchemaProperties")
    end

    def find_element_by_name(name)
      at_css("#element_#{name}")
    end

    def find_type_by_name(name)
      at_css("#type_#{name}")
    end

    def find_attribute_by_name(name)
      at_css("#attribute_#{name}")
    end

    def find_group_by_name(name)
      at_css("#group_#{name}")
    end

    def find_attribute_group_by_name(name)
      at_css("#attributeGroup_#{name}")
    end

    def find_notation_by_name(name)
      at_css("#notation_#{name}")
    end

    def css_includes
      head_section&.css('link[rel="stylesheet"]')&.map do |link|
        link["href"]
      end || []
    end

    def js_includes
      css("script[src]").map { |script| script["src"] }
    end

    def all_component_ids
      css("[id^='element_'], [id^='type_'], [id^='attribute_'], " \
          "[id^='group_'], [id^='attributeGroup_'], [id^='notation_']")
        .map { |el| el["id"] }
    end

    def has_section?(id)
      !component_section(id).nil?
    end

    def title
      at_xpath("//head/title")&.text
    end

    def meta_charset
      at_xpath('//head/meta[@charset]')&.[]("charset")
    end

    def doctype
      @doc.internal_subset&.name
    end

    def bootstrap_css_present?
      css_includes.any? { |href| href.include?("bootstrap") && href.include?(".css") }
    end

    def bootstrap_js_present?
      js_includes.any? { |src| src.include?("bootstrap") && src.include?(".js") }
    end

    def jquery_present?
      js_includes.any? { |src| src.include?("jquery") }
    end
  end
end