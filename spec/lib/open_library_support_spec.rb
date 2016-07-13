require 'rails_helper'
require 'open_library_support'

RSpec.describe OpenLibrarySupport, as: :lib do
  it 'can be instantiated with a path' do
    ols = OpenLibrarySupport.new('spec/samples/export')
    expect(ols).to_not be_nil
  end

  describe 'handling etl edge cases' do

    let(:ols) { OpenLibrarySupport.new('spec/samples/export') }


    it 'handles variour lcc formats' do
      expect(ols.safe_lcc(nil)).to be_nil
      expect(ols.safe_lcc([])).to be_nil
      expect(ols.safe_lcc([''])).to be_nil
      expect(ols.safe_lcc('AB123.123')).to eq('AB123.123')
      expect(ols.safe_lcc(['AB123.123'])).to eq('AB123.123')
    end

    it 'can handle tags that are strings or hashes' do

      hash = HashWithIndifferentAccess.new({
        "subject_places": [
          "Russia (Federation)", 
          "Sakhalin (Sakhalinskai\ufe20a\ufe21 oblast\u02b9)", 
          "Sakhalin (Russia)", 
          "Sakhalin", 
          "Sakhalin (Sakhalinskai\ufe20a\ufe21 oblast\u02b9, Russia)"], 
        "subject_people": [
          {"type": "/type/text", "value": "Anton Pavlovich Chekhov (1860-1904)"}] })

      arr = []
      ols.add_tags(arr, hash, 'subject_places', 'place')
      ols.add_tags(arr, hash, 'subject_people', 'person')

      expect(arr.count).to eq(6)
      expect(arr.first[:name]).to eq('place')
      expect(arr.first[:value]).to eq('Russia (Federation)')
      expect(arr.last[:name]).to eq('person')
      expect(arr.last[:value]).to eq('Anton Pavlovich Chekhov (1860-1904)')

    end

    it 'can handle stupid dates' do

      tests = [
        [ 'publish_date', 2004, { "publish_date" => "MAY 2004 ISBN: 9780061827389" } ],
        [ 'birth_date', 1951, { "birth_date" => "10 MAY 1951" } ],
        [ 'death_date', 2012, { "death_date" => { "key" => "/type/datetime", "value" => "2012-01-12" } } ],
        [ 'birth_date', 1941, { "birth_date" => "12/12/1941" } ],
        [ 'publish_date', 1040, { "publish_date" => "ca.1040" } ],
        [ 'birth_date', 1955, { "birth_date" => "June 12, 1955" } ]
      ]

      tests.each do |arr|
        expect(ols.safe_year(arr[2], arr[0])).to eq(arr[1])
      end

      expect(ols.safe_year({ "publish_date" => "11110002834756" }, 'publish_date')).to be_nil

    end
  end
end
