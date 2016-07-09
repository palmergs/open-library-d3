require 'rails_helper'

RSpec.describe Api::V1::WorksController, type: :controller do

  describe '#index' do
    it 'can return works' do
      create(:work)
      get :index
      works = assigns(:works)
      expect(works.count).to eq(1)
    end
  end

  describe '#show' do
    it 'can return a work' do
      w = create(:work)
      get :show, id: w.id
      work = assigns(:work)
      expect(work).to eq(w)
    end
  end
end
