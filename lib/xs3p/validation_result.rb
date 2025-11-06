# frozen_string_literal: true

module Xs3p
  # Encapsulates validation outcomes with errors, warnings, and status
  class ValidationResult
    attr_reader :errors, :warnings, :context

    def initialize(context = nil)
      @context = context
      @errors = []
      @warnings = []
    end

    def valid?
      @errors.empty?
    end

    def invalid?
      !valid?
    end

    def add_error(message, location: nil)
      error_text = location ? "#{location}: #{message}" : message
      @errors << error_text
    end

    def add_warning(message, location: nil)
      warning_text = location ? "#{location}: #{message}" : message
      @warnings << warning_text
    end

    def merge(other_result)
      @errors.concat(other_result.errors)
      @warnings.concat(other_result.warnings)
      self
    end

    def to_report
      lines = []
      lines << "Validation Report"
      lines << "=" * 80
      lines << "Context: #{context}" if context
      lines << "Status: #{valid? ? 'VALID' : 'INVALID'}"
      lines << ""

      unless errors.empty?
        lines << "Errors (#{errors.size}):"
        errors.each_with_index do |error, index|
          lines << "  #{index + 1}. #{error}"
        end
        lines << ""
      end

      unless warnings.empty?
        lines << "Warnings (#{warnings.size}):"
        warnings.each_with_index do |warning, index|
          lines << "  #{index + 1}. #{warning}"
        end
        lines << ""
      end

      lines.join("\n")
    end
  end
end