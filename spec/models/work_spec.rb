require 'rails_helper'

RSpec.describe Work, type: :model do
  it 'can be instantiated' do
    expect(Work.new).to_not be_nil
  end
end
