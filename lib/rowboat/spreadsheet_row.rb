require 'date'

module Rowboat
  class SpreadsheetRow
    @@parsers = {}

    def initialize(data)
      @data = data
    end

    def self.parser(attr, callback)
      @@parsers[attr] = callback
    end

    def self.parse(attr, value)
      unless @@parsers[attr].present?
        raise "No such parser: \"#{attr}\"" and return
      end

      @@parsers[attr].call(value)
    end

    def value(key)
      if @@parsers.has_key?(key)
        @@parsers[key].call(@data[key].to_s)
      else
        @data[key].to_s
      end
    end

    def date(key, format)
      Date.strptime(value(key), format)
    end
  end
end
