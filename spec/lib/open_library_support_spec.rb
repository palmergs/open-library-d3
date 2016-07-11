require 'rails_helper'
require 'open_library_support'

RSpec.describe OpenLibrarySupport, as: :lib do
  it 'can be instantiated with a path' do
    ols = OpenLibrarySupport.new('spec/samples/export')
    expect(ols).to_not be_nil
    expect(ols.authors_path).to include('spec/samples/export/authors.txt')
    expect(ols.works_path).to include('spec/samples/export/works.txt')
    expect(ols.editions_path).to include('spec/samples/export/editions.txt')
  end

  it 'throws an exception if all the required files are not found' do
    expect { OpenLibrarySupport.new('this/does/not/exists') }.to raise_error(RuntimeError)
  end

  describe 'parsing open library files' do
    let(:ols) { OpenLibrarySupport.new('spec/samples/export') }

    it 'can parse works, authors and editions' do
      cnt = ols.read_authors
      expect(cnt).to eq(11)

      cnt = ols.read_works
      expect(cnt).to eq(11)

      cnt = ols.read_editions
      expect(cnt).to eq(11)
    end
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

      hash = HashWithIndifferentAccess.new({"subject_places": ["Russia (Federation)", "Sakhalin (Sakhalinskai\ufe20a\ufe21 oblast\u02b9)", "Sakhalin (Russia)", "Sakhalin", "Sakhalin (Sakhalinskai\ufe20a\ufe21 oblast\u02b9, Russia)"], "subject_people": [{"type": "/type/text", "value": "Anton Pavlovich Chekhov (1860-1904)"}] })

      obj = create(:author)
      ols.add_tags(hash, obj, 'subject_places', 'place')
      ols.add_tags(hash, obj, 'subject_people', 'person')
      obj.reload

      expect(obj.subject_tags.where(name: 'place').count).to eq(5)
      expect(obj.subject_tags.where(name: 'place').first.value).to eq('Russia (Federation)')
      expect(obj.subject_tags.where(name: 'person').count).to eq(1)
      expect(obj.subject_tags.where(name: 'person').first.value).to eq('Anton Pavlovich Chekhov (1860-1904)')

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

    end
  end
end
