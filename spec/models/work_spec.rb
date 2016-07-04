require 'rails_helper'

RSpec.describe Work, type: :model do
  it 'can be instantiated' do
    expect(Work.new).to_not be_nil
  end

  it 'can be persisted' do
    expect(create(:work)).to be_persisted
    expect(create(:work)).to be_persisted
  end
end
