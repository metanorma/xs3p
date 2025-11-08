# frozen_string_literal: true

require "nokogiri"

require_relative "xs3p/version"
require_relative "xs3p/transformer"
require_relative "xs3p/html_document"
require_relative "xs3p/test_fixture_manager"
require_relative "xs3p/validation_result"

# Validators
require_relative "xs3p/validators/base_validator"
require_relative "xs3p/validators/section_validator"
require_relative "xs3p/validators/component_validator"
require_relative "xs3p/validators/table_validator"

# Document validators
require_relative "xs3p/validators/document/document_structure_validator"
require_relative "xs3p/validators/document/head_section_validator"
require_relative "xs3p/validators/document/navigation_validator"
require_relative "xs3p/validators/document/schema_properties_validator"

# Component validators
require_relative "xs3p/validators/components/element_section_validator"
require_relative "xs3p/validators/components/complex_type_section_validator"

# Content validators
require_relative "xs3p/validators/content/properties_table_validator"
require_relative "xs3p/validators/content/instance_representation_validator"

# Feature validators
require_relative "xs3p/validators/features/svg_reference_validator"
require_relative "xs3p/validators/features/css_style_validator"
require_relative "xs3p/validators/features/javascript_block_validator"

# Main module for XS3P test suite
module Xs3p
end