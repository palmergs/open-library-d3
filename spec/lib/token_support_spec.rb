require 'rails_helper'
require 'token_support'

RSpec.describe TokenSupport, as: :lib do

  it 'can be instantiated' do
    expect(TokenSupport.new).to_not be_nil
  end

  describe 'normalization' do

    it 'can extract normalized ASCII tokens from input strings' do
      samples = {
        'I͡U︡bileĭnye posvi͡a︡shchennye 70-letii͡u︡ so (1988 Moscow, Russia' => [ '1988', '70-letiiu', 'iubileinye', 'moscow' ],
        "(Canyon O'Grady)" => [ 'canyon', "o'grady" ],
        "Große Ferien im August" => [ 'grosse', 'ferien', 'im', 'august' ],
        "Research studies reporting experimental effects in the moral/ethical/values domain" => ["research", "studies", "reporting", "experimental", "effects", "in", "the", "moral", "ethical", "values", "domain"]
      }

      samples.each_pair do |string, tokens|
        extracted = TokenSupport.tokenize(string)
        tokens.each do |token|
          expect(extracted).to include(token)
        end
      end
    end
  end


  describe 'token generation' do

    let(:ts) { TokenSupport.new }

    it 'can generate tokens from authors' do

      author = create(:author, birth_date: 1922, death_date: 1992, description: Faker::Hipster.paragraph)
      ts.process_authors
      
    end

    it 'can generate tokens from works' do

      work = create(:work, publish_date: 1987, excerpt: Faker::Hipster.sentence, description: Faker::Hipster.paragraph)
      ts.process_works

    end

    it 'can generate tokens from editions' do

      10.times { create(:edition, publish_date: 1934, description: Faker::Hipster.paragraph) }
      ts.process_editions

    end
  end
end
