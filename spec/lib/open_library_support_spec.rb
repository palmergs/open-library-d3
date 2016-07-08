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
end
