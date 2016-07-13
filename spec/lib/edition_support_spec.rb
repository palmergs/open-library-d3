require 'rails_helper'
require 'open_library_support'
require 'edition_support'

RSpec.describe EditionSupport, as: :lib do
  it 'can be instantiated with a path' do
    ols = EditionSupport.new('spec/samples/export')
    expect(ols).to_not be_nil
    expect(ols.editions_path).to include('spec/samples/export/editions.txt')
  end

  it 'throws an exception if the required file is not found' do
    expect { EditionSupport.new('this/does/not/exists') }.to raise_error(RuntimeError)
  end

  describe 'parsing open library files' do
    let(:ols) { EditionSupport.new('spec/samples/export') }
  end

  describe 'parsing open library files' do
    let(:ols) { EditionSupport.new('spec/samples/export') }

    it 'can read sample files' do
      cnt = ols.read

      pp cnt
      pp Edition.all
      pp SubjectTag.all
      pp ExternalLink.all
    end
  end
end
