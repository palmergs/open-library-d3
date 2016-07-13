require 'rails_helper'
require 'open_library_support'
require 'work_support'

RSpec.describe WorkSupport, as: :lib do
  it 'can be instantiated with a path' do
    ols = WorkSupport.new('spec/samples/export')
    expect(ols).to_not be_nil
    expect(ols.works_path).to include('spec/samples/export/works.txt')
  end

  it 'throws an exception if the required file is not found' do
    expect { WorkSupport.new('this/does/not/exists') }.to raise_error(RuntimeError)
  end

  describe 'parsing open library files' do
    let(:ols) { WorkSupport.new('spec/samples/export') }
  end

  describe 'parsing open library files' do
    let(:ols) { WorkSupport.new('spec/samples/export') }

    it 'can read sample files' do
      cnt = ols.read

      pp cnt
      pp Work.all
      pp SubjectTag.all
      pp ExternalLink.all
    end
  end
end
