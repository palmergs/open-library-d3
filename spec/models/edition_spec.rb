require 'rails_helper'

RSpec.describe Edition, type: :model do
  it 'can be instantiated' do
    expect(Edition.new).to_not be_nil
  end
end
