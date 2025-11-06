# frozen_string_literal: true

require "spec_helper"

RSpec.describe "XS3P Transformation" do
  let(:fixture_manager) { Xs3p::TestFixtureManager.new }

  describe "recursive_groups.xsd transformation" do
    let(:document) { transform_xsd(fixture_manager.recursive_groups_fixture) }

    it "produces valid HTML5 document" do
      validator = Xs3p::Validators::Document::DocumentStructureValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes proper head section with meta, title, CSS and JS" do
      validator = Xs3p::Validators::Document::HeadSectionValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes navigation sidebar" do
      validator = Xs3p::Validators::Document::NavigationValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes schema properties section" do
      validator = Xs3p::Validators::Document::SchemaPropertiesValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes element section with documentation" do
      validator = Xs3p::Validators::Components::ElementSectionValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes CSS syntax highlighting" do
      validator = Xs3p::Validators::Features::CssStyleValidator.new(document)
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes JavaScript dependencies" do
      validator = Xs3p::Validators::Features::JavascriptBlockValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end
  end

  describe "unitsml-v1.0.xsd transformation" do
    let(:document) { transform_xsd(fixture_manager.unitsml_fixture) }

    it "produces valid HTML5 document" do
      validator = Xs3p::Validators::Document::DocumentStructureValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes proper head section" do
      validator = Xs3p::Validators::Document::HeadSectionValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes navigation sidebar" do
      validator = Xs3p::Validators::Document::NavigationValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes schema properties section" do
      validator = Xs3p::Validators::Document::SchemaPropertiesValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes element section" do
      validator = Xs3p::Validators::Components::ElementSectionValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes complex type section" do
      validator = Xs3p::Validators::Components::ComplexTypeSectionValidator
        .new(document)
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes CSS syntax highlighting" do
      validator = Xs3p::Validators::Features::CssStyleValidator.new(document)
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end

    it "includes JavaScript dependencies" do
      validator = Xs3p::Validators::Features::JavascriptBlockValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end
  end

  describe "transformation with custom parameters" do
    let(:document) do
      transform_xsd(
        fixture_manager.recursive_groups_fixture,
        parameters: {
          title: "Custom Test Title",
          sortByComponent: "true"
        }
      )
    end

    it "uses custom title" do
      title = document.title
      expect(title).to include("Custom Test Title")
    end

    it "produces valid document structure" do
      validator = Xs3p::Validators::Document::DocumentStructureValidator.new(
        document
      )
      result = validator.validate

      expect(result).to be_valid, result.to_report
    end
  end
end