require 'rails_helper'

RSpec.describe Author, type: :model do
  it 'can be instantiated' do
    expect(Author.new).to_not be_nil
  end
end
