require 'rails_helper'

RSpec.describe ExternalLink, as: :model do
  it 'can be instantiated' do
    expect(ExternalLink.new).to_not be_nil
  end
end
