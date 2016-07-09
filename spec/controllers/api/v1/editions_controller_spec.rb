require 'rails_helper'

RSpec.describe Api::V1::EditionsController, type: :controller do

  describe '#index' do
    it 'can return editions' do
      create(:edition)
      get :index
      editions = assigns(:editions)
      expect(editions.count).to eq(1)
    end
  end

  describe '#show' do
    it 'can return a edition' do
      e = create(:edition)
      get :show, id: e.id
      edition = assigns(:edition)
      expect(edition).to eq(e)
    end
  end
end

