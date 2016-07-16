require 'rails_helper'

RSpec.describe SubjectTag, as: :model do
  it 'can be instantiated' do
    expect(SubjectTag.new).to_not be_nil
  end
end
