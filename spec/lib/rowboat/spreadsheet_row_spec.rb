require 'spec_helper'
require_relative '../../../lib/rowboat/spreadsheet_row'

RSpec.describe Rowboat::SpreadsheetRow do
  describe '#value' do
    let!(:content) do
      {
        'First name' => 'John',
        'Last name' => 'Smith',
        'Birthdate' => '5/10/1980'
      }
    end

    it 'returns the value' do
      row = Rowboat::SpreadsheetRow.new(content)
      expect(row.value('First name')).to eq('John')
    end

    context 'parser' do
      it 'invokes the parser' do
        row = Rowboat::SpreadsheetRow.new(content)

        Rowboat::SpreadsheetRow.parser(
          'Birthdate',
          -> (value) { Date.strptime(value, '%m/%d/%Y') }
        )

        expect(row.value('Birthdate').to_s).to eq('1980-05-10')
      end
    end
  end
end
