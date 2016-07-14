require 'rails_helper'
require 'author_support'
require 'work_support'
require 'edition_support'
require 'token_support'

RSpec.describe 'can import entities from file', as: :integration do


  it 'runs to completion' do

    path = 'spec/samples/export'

    as = AuthorSupport.new(path)
    as.read
    expect(Author.count).to eq(11)
    pp Author.select(:ident).map(&:ident)

    ws = WorkSupport.new(path)
    ws.read

    expect(Work.count).to eq(11)
    expect(WorkAuthor.count).to eq(1)

    es = EditionSupport.new(path)
    es.read

    expect(WorkEdition.count).to eq(11)


    ts = TokenSupport.new
    ts.process_all

  end

end
