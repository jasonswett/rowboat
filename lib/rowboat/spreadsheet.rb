require 'csv'

module Rowboat
  class Spreadsheet
    def initialize(content)
      @content = content
      @failed_rows = []
    end

    def self.write(filename, array_of_hashes)
      CSV.open(filename, 'wb') do |csv|
        csv << array_of_hashes.first.keys
        array_of_hashes.each { |hash| csv << hash.values }
      end

      filename
    end

    def self.consume_file!(filename)
      content = File.read(filename)
      self.new(content).consume!
    end

    def consume!
      ActiveRecord::Base.transaction do
        CSV.parse(@content, headers: true) do |data|
          consume_row(data)
        end

        save_failures
        on_finish
      end
    end

    def consume_row(data)
      begin
        process_row(data)
      rescue => e
        save_failure(e, data)
        on_error(e, data)
      end
    end

    def save_failures
      return unless @failed_rows.any?
      self.class.write('failures.csv', @failed_rows)
    end

    def save_failure(e, data)
      @failed_rows << data.to_h.merge('Error message' => e.message)
    end

    def on_error(e, data)
    end

    def on_finish
    end
  end
end
