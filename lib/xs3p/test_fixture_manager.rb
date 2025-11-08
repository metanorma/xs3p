# frozen_string_literal: true

module Xs3p
  # Manages XSD test fixtures
  class TestFixtureManager
    attr_reader :fixtures_dir

    DEFAULT_FIXTURES_DIR = File.expand_path(
      "../../tests",
      __dir__
    )

    def initialize(fixtures_dir: DEFAULT_FIXTURES_DIR)
      @fixtures_dir = fixtures_dir
    end

    def fixture_path(filename)
      File.join(@fixtures_dir, filename)
    end

    def read_fixture(filename)
      path = fixture_path(filename)
      raise "Fixture not found: #{path}" unless File.exist?(path)

      File.read(path)
    end

    def fixture_exists?(filename)
      File.exist?(fixture_path(filename))
    end

    def available_fixtures
      Dir.glob(File.join(@fixtures_dir, "*.xsd")).map do |path|
        File.basename(path)
      end
    end

    def recursive_groups_fixture
      "recursive_groups.xsd"
    end

    def unitsml_fixture
      "unitsml-v1.0.xsd"
    end
  end
end