require 'rails_helper'

RSpec.describe Token, type: :model do
  it 'can be instantiated' do
    expect(Token.new).to_not be_nil
  end

  it 'can be persisted' do
    expect(create(:token)).to be_persisted
    expect(create(:token)).to be_persisted
  end
end
