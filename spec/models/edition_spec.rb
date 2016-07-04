require 'rails_helper'

RSpec.describe Edition, type: :model do
  it 'can be instantiated' do
    expect(Edition.new).to_not be_nil
  end

  it 'can be persisted' do
    expect(create(:edition)).to be_persisted
    expect(create(:edition)).to be_persisted
  end
end
