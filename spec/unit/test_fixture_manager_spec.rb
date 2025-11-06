# frozen_string_literal: true

require "spec_helper"

RSpec.describe Xs3p::TestFixtureManager do
  let(:manager) { described_class.new }

  describe "#initialize" do
    it "uses default fixtures directory" do
      expect(manager.fixtures_dir).to include("tests")
    end
  end

  describe "#fixture_path" do
    it "returns full path to fixture file" do
      path = manager.fixture_path("test.xsd")

      expect(path).to include("tests")
      expect(path).to end_with("test.xsd")
    end
  end

  describe "#fixture_exists?" do
    it "returns true for existing fixtures" do
      expect(manager.fixture_exists?(manager.recursive_groups_fixture))
        .to be true
      expect(manager.fixture_exists?(manager.unitsml_fixture)).to be true
    end

    it "returns false for non-existing fixtures" do
      expect(manager.fixture_exists?("nonexistent.xsd")).to be false
    end
  end

  describe "#read_fixture" do
    it "reads fixture content" do
      content = manager.read_fixture(manager.recursive_groups_fixture)

      expect(content).to include("<xsd:schema")
    end

    it "raises error for non-existing fixture" do
      expect do
        manager.read_fixture("nonexistent.xsd")
      end.to raise_error(/Fixture not found/)
    end
  end

  describe "#available_fixtures" do
    it "returns list of available XSD fixtures" do
      fixtures = manager.available_fixtures

      expect(fixtures).to include(manager.recursive_groups_fixture)
      expect(fixtures).to include(manager.unitsml_fixture)
    end
  end

  describe "#recursive_groups_fixture" do
    it "returns fixture filename" do
      expect(manager.recursive_groups_fixture).to eq("recursive_groups.xsd")
    end
  end

  describe "#unitsml_fixture" do
    it "returns fixture filename" do
      expect(manager.unitsml_fixture).to eq("unitsml-v1.0.xsd")
    end
  end
end