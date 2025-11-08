# frozen_string_literal: true

require "spec_helper"

RSpec.describe Xs3p::HtmlDocument do
  let(:html_string) do
    <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <meta charset="UTF-8">
        <title>Test Document</title>
        <link rel="stylesheet" href="bootstrap.min.css">
      </head>
      <body>
        <nav>
          <ul class="nav nav-list">
            <li><a href="#SchemaProperties">Schema Properties</a></li>
          </ul>
        </nav>
        <div id="SectionSchemaProperties">
          <h2>Schema Properties</h2>
        </div>
        <div id="element_testElement">
          <h3>testElement</h3>
        </div>
        <script src="jquery.min.js"></script>
        <script src="bootstrap.min.js"></script>
      </body>
      </html>
    HTML
  end

  let(:nokogiri_doc) { Nokogiri::HTML(html_string) }
  let(:document) { described_class.new(nokogiri_doc) }

  describe "#initialize" do
    it "wraps a Nokogiri document" do
      expect(document.doc).to eq(nokogiri_doc)
    end
  end

  describe "#css" do
    it "returns matching elements" do
      elements = document.css("nav")

      expect(elements).not_to be_empty
    end
  end

  describe "#at_css" do
    it "returns first matching element" do
      element = document.at_css("nav")

      expect(element).not_to be_nil
      expect(element.name).to eq("nav")
    end
  end

  describe "#head_section" do
    it "returns the head element" do
      head = document.head_section

      expect(head).not_to be_nil
      expect(head.name).to eq("head")
    end
  end

  describe "#navigation_section" do
    it "returns the nav element" do
      nav = document.navigation_section

      expect(nav).not_to be_nil
      expect(nav.name).to eq("nav")
    end
  end

  describe "#component_section" do
    it "returns element by ID" do
      section = document.component_section("SectionSchemaProperties")

      expect(section).not_to be_nil
      expect(section["id"]).to eq("SectionSchemaProperties")
    end
  end

  describe "#find_element_by_name" do
    it "finds element by name" do
      element = document.find_element_by_name("testElement")

      expect(element).not_to be_nil
      expect(element["id"]).to eq("element_testElement")
    end
  end

  describe "#css_includes" do
    it "returns CSS hrefs" do
      includes = document.css_includes

      expect(includes).to include("bootstrap.min.css")
    end
  end

  describe "#js_includes" do
    it "returns JavaScript sources" do
      includes = document.js_includes

      expect(includes).to include("jquery.min.js")
      expect(includes).to include("bootstrap.min.js")
    end
  end

  describe "#title" do
    it "returns document title" do
      expect(document.title).to eq("Test Document")
    end
  end

  describe "#meta_charset" do
    it "returns charset value" do
      expect(document.meta_charset).to eq("UTF-8")
    end
  end

  describe "#doctype" do
    it "returns doctype name" do
      expect(document.doctype).to eq("html")
    end
  end

  describe "#bootstrap_css_present?" do
    it "returns true when Bootstrap CSS is included" do
      expect(document.bootstrap_css_present?).to be true
    end
  end

  describe "#bootstrap_js_present?" do
    it "returns true when Bootstrap JS is included" do
      expect(document.bootstrap_js_present?).to be true
    end
  end

  describe "#jquery_present?" do
    it "returns true when jQuery is included" do
      expect(document.jquery_present?).to be true
    end
  end
end