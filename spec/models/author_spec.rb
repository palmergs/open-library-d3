require 'rails_helper'

RSpec.describe Author, type: :model do
  it 'can be instantiated' do
    expect(Author.new).to_not be_nil
  end

  it 'can be persisted' do
    expect(create(:author)).to be_persisted
    expect(create(:author)).to be_persisted
  end
end
