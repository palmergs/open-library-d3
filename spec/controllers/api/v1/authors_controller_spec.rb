require 'rails_helper'

RSpec.describe Api::V1::AuthorsController, type: :controller do

  describe '#index' do
    it 'can return authors' do
      create(:author)
      get :index
      authors = assigns(:authors)
      expect(authors.count).to eq(1)
    end
  end

  describe '#show' do
    it 'can return a author' do
      a = create(:author)
      get :show, id: a.id
      author = assigns(:author)
      expect(author).to eq(a)
    end
  end
end
