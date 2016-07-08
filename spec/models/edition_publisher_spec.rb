require 'rails_helper'

RSpec.describe EditionPublisher, as: :model do
  it 'can be instantiated' do
    expect(EditionPublisher.new).to_not be_nil
  end

  it 'can be persisted' do
    expect(create(:edition_publisher)).to be_persisted
    expect(create(:edition_publisher)).to be_persisted
  end
end
