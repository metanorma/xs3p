# frozen_string_literal: true

require "spec_helper"

RSpec.describe Xs3p::ValidationResult do
  describe "#initialize" do
    it "creates a result with no errors or warnings" do
      result = described_class.new

      expect(result).to be_valid
      expect(result.errors).to be_empty
      expect(result.warnings).to be_empty
    end

    it "accepts a context parameter" do
      result = described_class.new("Test Context")

      expect(result.context).to eq("Test Context")
    end
  end

  describe "#add_error" do
    let(:result) { described_class.new }

    it "adds an error to the list" do
      result.add_error("Test error")

      expect(result.errors).to contain_exactly("Test error")
    end

    it "marks result as invalid" do
      result.add_error("Test error")

      expect(result).to be_invalid
      expect(result).not_to be_valid
    end

    it "adds error with location" do
      result.add_error("Test error", location: "line 42")

      expect(result.errors).to contain_exactly("line 42: Test error")
    end
  end

  describe "#add_warning" do
    let(:result) { described_class.new }

    it "adds a warning to the list" do
      result.add_warning("Test warning")

      expect(result.warnings).to contain_exactly("Test warning")
    end

    it "does not mark result as invalid" do
      result.add_warning("Test warning")

      expect(result).to be_valid
    end

    it "adds warning with location" do
      result.add_warning("Test warning", location: "section 5")

      expect(result.warnings).to contain_exactly("section 5: Test warning")
    end
  end

  describe "#merge" do
    let(:result1) { described_class.new }
    let(:result2) { described_class.new }

    it "merges errors from another result" do
      result1.add_error("Error 1")
      result2.add_error("Error 2")

      result1.merge(result2)

      expect(result1.errors).to contain_exactly("Error 1", "Error 2")
    end

    it "merges warnings from another result" do
      result1.add_warning("Warning 1")
      result2.add_warning("Warning 2")

      result1.merge(result2)

      expect(result1.warnings).to contain_exactly("Warning 1", "Warning 2")
    end
  end

  describe "#to_report" do
    let(:result) { described_class.new("Test Validator") }

    it "generates a report with context" do
      report = result.to_report

      expect(report).to include("Context: Test Validator")
      expect(report).to include("Status: VALID")
    end

    it "includes errors in the report" do
      result.add_error("Error 1")
      result.add_error("Error 2")

      report = result.to_report

      expect(report).to include("Errors (2)")
      expect(report).to include("Error 1")
      expect(report).to include("Error 2")
    end

    it "includes warnings in the report" do
      result.add_warning("Warning 1")

      report = result.to_report

      expect(report).to include("Warnings (1)")
      expect(report).to include("Warning 1")
    end
  end
end