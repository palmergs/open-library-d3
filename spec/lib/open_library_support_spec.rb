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
  end
end
