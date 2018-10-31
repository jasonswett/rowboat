require 'spec_helper'
require_relative '../../../lib/rowboat/spreadsheet'

RSpec.describe Rowboat::Spreadsheet do
  describe '#write' do
    let(:data) {
      [
        {
          'First name' => 'John',
          'Last name' => 'Smith',
          'Birthdate' => '5/10/1980'
        },
        {
          'First name' => 'Filbo',
          'Last name' => 'Muckleton',
          'Birthdate' => '7/18/1982'
        }
      ]
    }

    it 'writes a file' do
      filename = File.join('spec', 'files', 'data.csv')
      Rowboat::Spreadsheet.write(filename, data)
      content = File.read(filename)

      expected_content = %(First name,Last name,Birthdate
John,Smith,5/10/1980
Filbo,Muckleton,7/18/1982
)

      expect(content).to eq(expected_content)
    end
  end
end
