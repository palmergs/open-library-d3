require 'rails_helper'
require 'open_library_support'
require 'author_support'

RSpec.describe AuthorSupport, as: :lib do
  it 'can be instantiated with a path' do
    ols = AuthorSupport.new('spec/samples/export')
    expect(ols).to_not be_nil
    expect(ols.authors_path).to include('spec/samples/export/authors.txt')
  end

  it 'throws an exception if the required file is not found' do
    expect { AuthorSupport.new('this/does/not/exists') }.to raise_error(RuntimeError)
  end

  describe 'parsing open library files' do
    let(:ols) { AuthorSupport.new('spec/samples/export') }

    it 'can read sample files' do
      cnt = ols.read

      pp cnt
      pp Author.all
      pp SubjectTag.all
      pp ExternalLink.all
    end
  end
end

